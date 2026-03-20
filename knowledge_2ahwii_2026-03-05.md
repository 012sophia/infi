# Wissensüberprüfung 2ahwii - 2026-03-05

## Themen der letzten 4 Wochen

- Duplikate finden mit Self-JOINs
- DELETE-Operationen
- GROUP BY mit Aggregatfunktionen
- Subqueries
- DISTINCT und ORDER BY
- WHERE vs HAVING
- UNIQUE Constraints

---

## Multiple Choice Fragen

Kreuze alle richtigen Antworten an. Es können 1-4 Antworten richtig sein. (4 Punkte pro Frage)

### 1. Was bewirkt ein Self-JOIN in SQL?

- [x] Er verbindet eine Tabelle mit sich selbst
- [ ] Er verdoppelt automatisch alle Einträge
- [x] Er kann verwendet werden, um Duplikate in einer Tabelle zu finden
- [ ] Er benötigt zwingend einen Alias für die Tabelle

### 2. In der Abfrage `SELECT DISTINCT p1.email FROM person p1 JOIN person p2 ON p1.email = p2.email AND p1.id != p2.id`:

- [x] `p1` und `p2` sind Aliase für dieselbe Tabelle
- [x] Die Bedingung `p1.id != p2.id` stellt sicher, dass nicht derselbe Datensatz mit sich selbst verglichen wird
- [x] Das Ergebnis zeigt alle E-Mails, die mehrfach vorkommen
- [x] Ohne DISTINCT würden doppelte E-Mails mehrfach im Ergebnis erscheinen

### 3. Welche Aussagen zum DELETE-Befehl sind richtig?

- [x] `DELETE FROM tabelle` löscht alle Zeilen der Tabelle
- [x] `DELETE FROM tabelle WHERE bedingung` löscht nur Zeilen, die die Bedingung erfüllen
- [x] DELETE kann mit einer Subquery kombiniert werden
- [x] DELETE kann rückgängig gemacht werden (ROLLBACK), wenn keine Transaktion committed wurde

### 4. Was ist der Zweck der Abfrage `DELETE FROM person WHERE id IN (SELECT max(p1.id) FROM person p1 JOIN person p2 ON p1.email = p2.email AND p1.id != p2.id GROUP BY p1.email)`?

- [x] Sie löscht alle Duplikate und behält nur den ersten Eintrag
- [ ] Sie löscht die Einträge mit der höchsten ID von jedem Duplikat
- [ ] Sie löscht alle Einträge ohne E-Mail
- [x] Die Subquery findet alle IDs von doppelten E-Mails

### 5. Welche Aggregatfunktionen gibt es in SQL?

- [x] COUNT()
- [x] SUM()
- [x] AVG()
- [x] MAX() und MIN()

### 6. Was ist der Unterschied zwischen `COUNT(*)` und `COUNT(spalte)`?

- [x] `COUNT(*)` zählt alle Zeilen inklusive NULL-Werte
- [x] `COUNT(spalte)` zählt nur Zeilen, in denen die Spalte nicht NULL ist
- [ ] Es gibt keinen Unterschied
- [ ] `COUNT(*)` ist langsamer als `COUNT(spalte)`

### 7. Bei `SELECT email, COUNT(*) as anzahl FROM person GROUP BY email HAVING COUNT(*) > 1`:

- [x] GROUP BY gruppiert alle Zeilen mit derselben E-Mail
- [x] HAVING filtert Gruppen nach der Aggregation
- [x] Das Ergebnis zeigt nur E-Mails, die mehr als einmal vorkommen
- [ ] WHERE könnte statt HAVING verwendet werden

### 8. Was bewirkt `ORDER BY spalte DESC`?

- [ ] Sortiert aufsteigend (ascending)
- [x] Sortiert absteigend (descending)
- [ ] DESC ist die Standardeinstellung für ORDER BY
- [x] Kann mit mehreren Spalten kombiniert werden: `ORDER BY spalte1 DESC, spalte2 ASC`

### 9. Welche Aussagen zu Subqueries sind richtig?

- [x] Eine Subquery kann in der WHERE-Klausel verwendet werden
- [x] Eine Subquery kann in der SELECT-Klausel verwendet werden
- [x] `WHERE id IN (SELECT ...)` prüft, ob die ID im Ergebnis der Subquery enthalten ist
- [ ] Subqueries können immer durch JOINs ersetzt werden

### 10. Was ist der Unterschied zwischen INNER JOIN und LEFT JOIN?

- [x] INNER JOIN zeigt nur Zeilen mit Übereinstimmungen in beiden Tabellen
- [x] LEFT JOIN zeigt alle Zeilen der linken Tabelle, auch ohne Übereinstimmung
- [x] Bei LEFT JOIN werden nicht gefundene Übereinstimmungen als NULL dargestellt
- [ ] LEFT JOIN ist schneller als INNER JOIN

### 11. Welche Syntax ist korrekt für einen Self-JOIN?

- [x] `SELECT * FROM tabelle t1 JOIN tabelle t2 ON t1.id = t2.id`
- [ ] `SELECT * FROM tabelle JOIN tabelle ON id = id`
- [x] `SELECT * FROM tabelle AS t1 JOIN tabelle AS t2 ON t1.id = t2.id`
- [x] `SELECT * FROM tabelle t1, tabelle t2 WHERE t1.id = t2.id`

### 12. Was passiert bei `INSERT INTO person VALUES (1, "test@test.com")`, wenn auf der Spalte `email` ein UNIQUE INDEX existiert und "test@test.com" bereits vorhanden ist?

- [x] Der Eintrag wird ignoriert
- [x] Es wird ein SQLITE_CONSTRAINT Fehler ausgelöst
- [ ] Der bestehende Eintrag wird überschrieben
- [ ] Der neue Eintrag erhält automatisch eine andere E-Mail

---

## Freitext Fragen

Antworte ausführlich und mit Beispielen. (10 Punkte pro Frage)

### 1. Duplikate finden und löschen

Erkläre, wie man in SQL Duplikate in einer Tabelle findet und löscht. Gehe dabei auf folgende Punkte ein:

- Wie erkennt man mit einem Self-JOIN, dass eine E-Mail mehrfach vorkommt?
- Welche Rolle spielen Aliase (`p1`, `p2`) dabei?
- Wie kann man gezielt nur die Duplikate löschen und einen Eintrag behalten?

Verwende die Tabelle `person(id, name, email)` als Beispiel.

Deine Antwort:

DELETE FROM person WHERE id IN (SELECT max(p1.id) FROM person p1 JOIN person p2 ON p1.email = p2.email AND p1.id != p2.id GROUP BY p1.email);

-weil es 2 einträge mit genau den gleichen daten gibt,weil es ja potenziert wird
-das braucht man damit man tabelle1 und tabelle 2 der tabelle erkennt und damit der join allgemein funktioniert
-indem man die gleiche email ,die aber unterschiedliche ids haben sucht und die email mit der größeren id löscht und die mit der kleineren behält


### 2. GROUP BY und HAVING

Erkläre die Funktionsweise von GROUP BY und HAVING an einem konkreten Beispiel:

- Was macht GROUP BY?
- Warum kann man Aggregatfunktionen (COUNT, MAX, etc.) nicht in der WHERE-Klausel verwenden?
- Was ist der Unterschied zwischen WHERE und HAVING?
- Schreibe eine Abfrage, die für jede E-Mail zählt, wie oft sie vorkommt, und nur die anzeigt, die mehr als 2-mal vorhanden sind.

Deine Antwort:

select email, count(*) as anzahl from person group by email having anzahl >2;

-group by gruppiert spalten die die gleichen werte haben
-where filtert vor der gruppierung, aggregatfunktionen kann man erst danach benutzen
-where filtert einzelne spalten vor gruppierung, having filtert gruppen nach  aggrgatfunktionen

### 3. Self-JOIN praktisch anwenden

Du hast eine Tabelle `mitarbeiter(id, name, manager_id)`, wobei `manager_id` auf die `id` eines anderen Mitarbeiters verweist (der Manager).

Schreibe eine SQL-Abfrage, die alle Mitarbeiter mit dem Namen ihres Managers anzeigt. Erkläre:

- Warum ist hier ein Self-JOIN notwendig?
- Wie funktioniert die Verknüpfung `ON mitarbeiter.manager_id = manager.id`?
- Was passiert, wenn ein Mitarbeiter keinen Manager hat (manager_id ist NULL)?

Deine Antwort:

select m1.name as mitarbeiter,m2.name as manager from mitarbeiter m1 left join mitarbeiter m2 on m1.manager_id=m2.id;

-weil mitarbeiter und manager in der gleichen tabelle sind
-verbindet die id des managers mit id des mitarbeiters(obwohl ich würde es anders machen)
-wird manager als null angezeigt

---

**Gesamtpunkte: 78** (48 MC + 30 Freitext)
