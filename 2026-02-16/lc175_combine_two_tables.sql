-- LeetCode 175: Combine Two Tables
-- Zeige Vorname, Nachname, Stadt und Bundesland aller Personen
SELECT p.firstName, p.lastName, a.city, a.state
FROM Person p
LEFT JOIN Address a ON p.personId = a.personId;
