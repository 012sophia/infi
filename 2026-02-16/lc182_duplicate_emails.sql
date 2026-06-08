-- LeetCode 182: Duplicate Emails
-- Finde alle E-Mail-Adressen, die mehrfach vorkommen
SELECT email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;
