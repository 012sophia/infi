# Zusammenfassung: 2026-03-19 (SQL DDL & Constraints)

## Thema
SQL Data Definition Language (DDL) mit Constraint-Anwendungen

## Behandelte Inhalte
- Erstellung der Tabelle `personneu` mit:
  - `id` (int) als PRIMARY KEY
  - `name` (text) mit NOT NULL Constraint
  - `id_lieblingsessen` (number) mit FOREIGN KEY Constraint (referenziert `essen(id)`)
- Erstellung der Tabelle `essenneu` mit:
  - `id` (number) als PRIMARY KEY
  - `essen` (text) mit NOT NULL Constraint

## Quelldatei
`C:\HAM240106\2AHWII\INFI\GRG-INFI\2ahwii\2026-03-19_constraints\essen-ddl.sql`
