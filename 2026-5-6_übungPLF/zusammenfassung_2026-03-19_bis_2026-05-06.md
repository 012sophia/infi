# Zusammenfassung: 19. März – 6. Mai 2026 (PLF-Vorbereitung)

**PLF am 7. Mai 2026 – Praktische Leistungsfeststellung**

---

## 1. Theorie-Teil: Alle Befehle im Überblick

### A. DDL – Data Definition Language

#### Tabellen erstellen (CREATE TABLE)
```sql
CREATE TABLE person (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT    NOT NULL,
    email       TEXT    UNIQUE,
    alter_jahre INTEGER CHECK (alter_jahre >= 0)
);

CREATE TABLE bestellung (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    kunde_id   INTEGER NOT NULL,
    produkt_id INTEGER NOT NULL,
    menge      INTEGER NOT NULL DEFAULT 1,
    bewertung  INTEGER,
    FOREIGN KEY (kunde_id)   REFERENCES kunde(id),
    FOREIGN KEY (produkt_id) REFERENCES produkt(id)
);
```

#### Constraints (Integritätsregeln)
| Constraint | Bedeutung | Beispiel |
|------------|-----------|----------|
| `PRIMARY KEY` | Eindeutige Identifikation, automatisch NOT NULL | `id INTEGER PRIMARY KEY` |
| `AUTOINCREMENT` | Automatische ID-Vergabe | `id INTEGER PRIMARY KEY AUTOINCREMENT` |
| `NOT NULL` | Spalte darf nicht leer sein | `name TEXT NOT NULL` |
| `UNIQUE` | Keine doppelten Werte erlaubt | `email TEXT UNIQUE` |
| `CHECK` | Wertebereich prüfen | `CHECK (alter_jahre >= 0)` |
| `DEFAULT` | Standardwert, falls kein Wert angegeben | `menge INTEGER DEFAULT 1` |
| `FOREIGN KEY` | Verweis auf andere Tabelle | `FOREIGN KEY (kunde_id) REFERENCES kunde(id)` |

#### Foreign Key Verhalten (ON DELETE / ON UPDATE)
```sql
CREATE TABLE person_essen_rating (
    person_id INTEGER NOT NULL,
    essen_id  INTEGER NOT NULL,
    rating    INTEGER NOT NULL,
    PRIMARY KEY (person_id, essen_id),  -- Composite PK
    FOREIGN KEY (person_id) REFERENCES person_nm(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (essen_id)  REFERENCES essen_nm(id)  ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (rating >= 1 AND rating <= 5)
);
```

| Option | Bedeutung |
|--------|-----------|
| `CASCADE` | Abhängige Zeilen werden mitgelöscht/aktualisiert |
| `RESTRICT` | Löschen/Aktualisieren wird verhindert |
| `SET NULL` | Fremdschlüssel wird auf NULL gesetzt (nur ohne NOT NULL) |
| `NO ACTION` | Fehler wird geworfen (Standard) |

#### Foreign Keys aktivieren (wichtig in SQLite!)
```sql
PRAGMA foreign_keys = ON;
```

#### Tabellen löschen
```sql
DROP TABLE IF EXISTS bestellung;
```

#### Indexe (Leistungsoptimierung)
```sql
CREATE INDEX idx_person_name ON person(name);
CREATE INDEX IF NOT EXISTS idx_rating ON person_essen_rating(rating);
```
- SQLite erstellt **automatisch** Indexe für PRIMARY KEY und UNIQUE
- Indexe beschleunigen SELECT, JOIN, ORDER BY – verlangsamen INSERT/UPDATE

---

### B. DML – Data Manipulation Language

#### Daten einfügen (INSERT)
```sql
INSERT INTO person (name, email, alter_jahre) VALUES ('Anna', 'anna@mail.at', 17);
INSERT INTO person (name, email) VALUES ('Ben', 'ben@mail.at');  -- alter_jahre = NULL
```

#### Daten ändern (UPDATE)
```sql
UPDATE person SET email = 'new@mail.at' WHERE id = 1;
UPDATE bestellung SET bewertung = 5 WHERE id = 3;
```

#### Daten löschen (DELETE)
```sql
DELETE FROM person WHERE id = 1;
DELETE FROM bestellung WHERE bewertung IS NULL;
```

---

### C. DQL – Data Query Language (SELECT)

#### Grundlegende SELECT-Struktur (Ausführungsreihenfolge!)
```
1. FROM        → Welche Tabelle(n)?
2. WHERE       → Einzelne Zeilen filtern (VOR dem Gruppieren)
3. GROUP BY    → Zeilen zusammenfassen
4. HAVING      → Gruppen filtern (NACH dem Gruppieren)
5. SELECT      → Welche Spalten ausgeben?
6. ORDER BY    → Sortieren
```

#### Einfache Abfragen
```sql
SELECT vorname, nachname FROM person;
SELECT * FROM bestellung WHERE menge > 5;
SELECT name, preis FROM produkt ORDER BY preis DESC;
```

#### WHERE vs. HAVING (WICHTIG!)
```sql
-- WHERE: Filtert EINZELNE Zeilen (vor GROUP BY)
SELECT * FROM person WHERE alter_jahre >= 17;

-- HAVING: Filtert GRUPPEN (nach GROUP BY)
SELECT stadt, COUNT(*) AS anzahl
FROM person
GROUP BY stadt
HAVING anzahl >= 4;
```

#### COUNT(*) vs. COUNT(Spalte)
```sql
SELECT COUNT(*) AS total, COUNT(bewertung) AS bewertete
FROM bestellung;
-- COUNT(*): zählt ALLE Zeilen inkl. NULL
-- COUNT(bewertung): zählt nur Zeilen, wo bewertung NICHT NULL
```

#### GROUP BY mit Aggregatfunktionen
```sql
SELECT kunde_id, COUNT(*) AS anzahl_bestellungen, AVG(bewertung) AS durchschnitt
FROM bestellung
GROUP BY kunde_id
ORDER BY anzahl_bestellungen DESC;
```

#### JOINs (Tabellen verbinden)
```sql
-- INNER JOIN: Nur passende Datensätze
SELECT p.name, b.datum, b.menge
FROM kunde k
JOIN bestellung b ON k.id = b.kunde_id;

-- LEFT JOIN: Alle Kunden, auch ohne Bestellungen
SELECT k.name, COUNT(b.id) AS anzahl
FROM kunde k
LEFT JOIN bestellung b ON k.id = b.kunde_id
GROUP BY k.id;
```

#### Self-JOIN (Tabelle mit sich selbst verbinden)
```sql
-- Doppelte E-Mails finden
SELECT p1.id, p1.name, p2.id, p2.name, p1.email
FROM person p1
JOIN person p2 ON p1.email = p2.email AND p1.id < p2.id;

-- Mitarbeiter und ihr Chef
SELECT m1.name AS mitarbeiter, m2.name AS chef
FROM mitarbeiter m1
JOIN mitarbeiter m2 ON m1.chef_id = m2.id;
```

#### ORDER BY (Sortierung)
```sql
-- Einzelne Spalte
SELECT * FROM person ORDER BY alter_jahre DESC;

-- Mehrfachsortierung (bei Gleichstand)
SELECT vorname, nachname, stadt, alter_jahre
FROM person
ORDER BY stadt ASC, alter_jahre DESC, nachname ASC;
```

#### String-Verknüpfung (SQLite)
```sql
SELECT vorname || ' ' || nachname AS vollname FROM person;
```

#### LIKE (Mustervergleich)
```sql
SELECT * FROM person WHERE email LIKE '%@mail.at';
SELECT * FROM produkt WHERE name LIKE 'Wireless%';
```

---

### D. ER-Modellierung mit bigER

#### Entities (Entitäten)
```erd
entity person {
    id key
    name
    email optional
    alter_jahre
}
```

#### Relationships (Beziehungen)
```erd
-- 1:N Beziehung
relationship Leihe {
    leser [1] -> ausleihe [N]
}

-- N:M Beziehung
relationship Belegt {
    student [N] -> kurs [M]
    note
    datum
}
```

#### Attribute-Modifier
| Keyword | Bedeutung |
|---------|-----------|
| `key` | Primary Key |
| `optional` | Nullable (NULL erlaubt) |
| `derived` | Abgeleitetes Attribut |
| `multi-valued` | Mehrwertiges Attribut |

#### N:M Entscheidung: Relationship vs. Entity
- **Relationship mit Attributen**: Wenig Daten, nur Verbindung
- **Entity**: Eigenes ID nötig, viele Attribute, andere Tabellen verweisen darauf

Beispiel Bibliothek:
```erd
entity ausleihe {
    id_ausleihe key
    ausleihdatum
    rueckgabedatum optional
}

relationship LeserLeihe {
    leser [1] -> ausleihe [N]
}
relationship ExemplarLeihe {
    exemplar [1] -> ausleihe [N]
}
```

---

## 2. Praktischer Teil: Übungen für die PLF

### Setup (vor den Übungen ausführen)
```sql
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS bestellung;
DROP TABLE IF EXISTS produkt;
DROP TABLE IF EXISTS kunde;
DROP TABLE IF EXISTS person;

CREATE TABLE person (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    vorname     TEXT    NOT NULL,
    nachname    TEXT    NOT NULL,
    email       TEXT,
    stadt       TEXT,
    alter_jahre INTEGER
);

INSERT INTO person (vorname, nachname, email, stadt, alter_jahre) VALUES
    ('Anna',     'Müller',   'anna.mueller@mail.at',     'Wien',      17),
    ('Bernhard', 'Gruber',   'bernhard.gruber@mail.at',  'Graz',      16),
    ('Clara',    'Müller',   'anna.mueller@mail.at',     'Linz',      17),
    ('David',    'Huber',    'david.huber@mail.at',      'Wien',      18),
    ('Eva',      'Bauer',    'eva.bauer@mail.at',        'Salzburg',  16),
    ('Felix',    'Wagner',   'felix.wagner@mail.at',     'Wien',      17),
    ('Greta',    'Huber',    'greta.huber@mail.at',      'Graz',      15),
    ('Hans',     'Bauer',    'eva.bauer@mail.at',        'Linz',      18),
    ('Iris',     'Schmidt',  'iris.schmidt@mail.at',     'Wien',      17),
    ('Jakob',    'Fischer',  'jakob.fischer@mail.at',    'Graz',      16);

CREATE TABLE kunde (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    name  TEXT    NOT NULL,
    stadt TEXT    NOT NULL
);

INSERT INTO kunde (name, stadt) VALUES
    ('TechCorp',  'Wien'),
    ('DataSoft',  'Graz'),
    ('CloudNet',  'München');

CREATE TABLE produkt (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT    NOT NULL,
    kategorie TEXT    NOT NULL,
    preis     REAL    NOT NULL
);

INSERT INTO produkt (name, kategorie, preis) VALUES
    ('Laptop Pro',    'Hardware', 1299.99),
    ('Wireless Maus', 'Hardware', 29.99),
    ('Office Suite',  'Software', 149.99);

CREATE TABLE bestellung (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    kunde_id   INTEGER NOT NULL,
    produkt_id INTEGER NOT NULL,
    menge      INTEGER NOT NULL,
    bewertung  INTEGER,
    FOREIGN KEY (kunde_id)   REFERENCES kunde(id),
    FOREIGN KEY (produkt_id) REFERENCES produkt(id)
);

INSERT INTO bestellung (kunde_id, produkt_id, menge, bewertung) VALUES
    (1, 1, 2, 5),
    (1, 3, 1, NULL),
    (2, 2, 5, 4),
    (2, 1, 3, 5),
    (3, 2, 10, 3),
    (3, 3, 1, NULL);
```

---

### Übung 1: WHERE vs. HAVING

**Aufgabe 1a:** Schreibe die SQL-Klauseln in der richtigen Ausführungsreihenfolge:
```sql
-- 1. ___
-- 2. ___
-- 3. ___
-- 4. ___
-- 5. ___
-- 6. ___
```

**Aufgabe 1b:** Finde alle Städte, in denen **mindestens 2 Personen** leben.
```sql
-- Deine Lösung:

```

**Aufgabe 1c:** Finde alle Städte (außer Wien), in denen **mindestens 2 Personen** leben.
```sql
-- Deine Lösung:

```

---

### Übung 2: COUNT(*) vs. COUNT(Spalte)

**Aufgabe 2a:** Was ist das Ergebnis (vorher sagen!)?
```sql
SELECT COUNT(*) AS total, COUNT(bewertung) AS bewertete FROM bestellung;
-- total = ___
-- bewertete = ___
```

**Aufgabe 2b:** Für jeden Kunden: Gesamtanzahl Bestellungen und Anzahl bewertete Bestellungen.
```sql
-- Deine Lösung:

```

**Aufgabe 2c:** Nur Kunden, bei denen mehr bewertete als unbewertete Bestellungen.
```sql
-- Deine Lösung:

```

---

### Übung 3: Self-JOIN

**Aufgabe 3a:** Finde alle Paare von Personen mit derselben E-Mail (aber unterschiedliche IDs).
Ausgabe: `p1_name`, `p2_name`, `email`. Sortiert nach `p1_name`.
```sql
-- Deine Lösung:

```

**Aufgabe 3b:** Erstelle eine Tabelle `mitarbeiter` und finde Mitarbeiter, die mehr verdienen als ihr Chef.
```sql
-- Setup:
CREATE TABLE mitarbeiter (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT    NOT NULL,
    gehalt  REAL    NOT NULL,
    chef_id INTEGER,
    FOREIGN KEY (chef_id) REFERENCES mitarbeiter(id)
);
INSERT INTO mitarbeiter (name, gehalt, chef_id) VALUES
    ('Chef',       8000, NULL),
    ('Mitarbeiter', 5000, 1),
    ('Azubi',      3000, 2);

-- Deine Lösung (wer verdient mehr als sein Chef?):

```

---

### Übung 4: ORDER BY (Mehrfachsortierung)

**Aufgabe 4a:** Alle Personen, sortiert nach Alter **absteigend**, bei Gleichstand nach Nachname **aufsteigend**.
```sql
-- Deine Lösung:

```

**Aufgabe 4b:** Alle Bestellungen, sortiert nach:
1. Kunde aufsteigend
2. Menge absteigend
3. Bewertung aufsteigend (NULL zuerst)
```sql
-- Deine Lösung:

```

---

### Übung 5: N:M Beziehung (DDL)

**Aufgabe 5a:** Erstelle eine Datenbank für Schüler und Kurse:
- `schueler`: id (PK, Auto), name (NOT NULL), klasse
- `kurs`: id (PK, Auto), titel (NOT NULL), bezeichnung (UNIQUE)
- `schueler_kurs`: Zwischentabelle mit Composite PK (schueler_id, kurs_id), note (1-5, CHECK)

```sql
-- Deine Lösung:

```

**Aufgabe 5b:** Füge Testdaten ein und zeige alle Schüler mit ihren Kursen und Noten.
```sql
-- Deine Lösung:

```

---

### Übung 6: FOREIGN KEY Verhalten

**Aufgabe 6a:** Was passiert bei folgendem Befehl (CASCADE aktiv)?
```sql
DELETE FROM kunde WHERE id = 1;
```
Erklärung: _______________________________________________

**Aufgabe 6b:** Wie verhindert man das Löschen eines Kunden, der noch Bestellungen hat?
Ändere das FOREIGN KEY Constraint entsprechend:
```sql
-- Deine Lösung (ALTER TABLE oder neue CREATE TABLE):

```

---

### Übung 7: ER-Modellierung (bigER)

**Aufgabe 7a:** Modelliere folgendes Szenario in bigER:
- Entität `Buch`: id (key), titel, autor, isbn (UNIQUE)
- Entität `Leser`: id (key), name, email (optional)
- N:M Beziehung `Ausleihe` mit Attribut `datum`

```erd
-- Deine Lösung:

```

**Aufgabe 7b:** Wann würdest du aus der Relationship `Ausleihe` eine eigene Entity machen?
Erklärung: _______________________________________________

---

## 3. Musterlösungen (für Selbstkontrolle)

### Übung 1
```sql
-- 1a:
-- 1. FROM
-- 2. WHERE
-- 3. GROUP BY
-- 4. HAVING
-- 5. SELECT
-- 6. ORDER BY

-- 1b:
SELECT stadt, COUNT(*) AS anzahl FROM person GROUP BY stadt HAVING anzahl >= 2 ORDER BY stadt;

-- 1c:
SELECT stadt, COUNT(*) AS anzahl FROM person WHERE stadt != 'Wien' GROUP BY stadt HAVING anzahl >= 2;
```

### Übung 2
```sql
-- 2a: total=6, bewertete=4

-- 2b:
SELECT kunde_id, COUNT(*) AS total, COUNT(bewertung) AS bewertete FROM bestellung GROUP BY kunde_id;

-- 2c:
SELECT kunde_id, COUNT(*) AS total, COUNT(bewertung) AS bewertete
FROM bestellung
GROUP BY kunde_id
HAVING COUNT(bewertung) > COUNT(*) - COUNT(bewertung);
```

### Übung 3
```sql
-- 3a:
SELECT p1.vorname || ' ' || p1.nachname AS p1_name,
       p2.vorname || ' ' || p2.nachname AS p2_name,
       p1.email
FROM person p1
JOIN person p2 ON p1.email = p2.email AND p1.id < p2.id
ORDER BY p1_name;

-- 3b:
SELECT m1.name AS mitarbeiter, m1.gehalt, m2.name AS chef, m2.gehalt AS chef_gehalt
FROM mitarbeiter m1
JOIN mitarbeiter m2 ON m1.chef_id = m2.id
WHERE m1.gehalt > m2.gehalt;
```

### Übung 4
```sql
-- 4a:
SELECT * FROM person ORDER BY alter_jahre DESC, nachname ASC;

-- 4b:
SELECT * FROM bestellung ORDER BY kunde_id ASC, menge DESC, bewertung ASC;
```

### Übung 5
```sql
-- 5a:
CREATE TABLE schueler (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT    NOT NULL,
    klasse  TEXT
);

CREATE TABLE kurs (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    titel       TEXT    NOT NULL,
    bezeichnung TEXT    UNIQUE
);

CREATE TABLE schueler_kurs (
    schueler_id INTEGER NOT NULL,
    kurs_id     INTEGER NOT NULL,
    note        INTEGER NOT NULL,
    PRIMARY KEY (schueler_id, kurs_id),
    FOREIGN KEY (schueler_id) REFERENCES schueler(id) ON DELETE CASCADE,
    FOREIGN KEY (kurs_id)     REFERENCES kurs(id)     ON DELETE CASCADE,
    CHECK (note >= 1 AND note <= 5)
);
```

### Übung 6
```sql
-- 6a: Durch ON DELETE CASCADE werden alle Bestellungen von Kunde 1 automatisch gelöscht.

-- 6b: ON DELETE RESTRICT verwenden (oder NO ACTION):
FOREIGN KEY (kunde_id) REFERENCES kunde(id) ON DELETE RESTRICT
```

### Übung 7
```erd
-- 7a:
entity Buch {
    id key
    titel
    autor
    isbn unique
}

entity Leser {
    id key
    name
    email optional
}

relationship Ausleihe {
    Leser [N] -> Buch [M]
    datum
}
```
