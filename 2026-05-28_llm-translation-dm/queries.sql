-- Beispiel-Abfragen für das LLM-Übersetzungs-Datenmodell
-- (SQL-Äquivalent der Prisma-Queries)

-- Alle LLM-Modelle mit ihren Sprachkenntnissen
SELECT lm.name, l.englishName, lp.proficiencyLevel
FROM llm_models lm
JOIN language_proficiencies lp ON lm.id = lp.llmModelId
JOIN languages l ON lp.languageId = l.id
ORDER BY lm.name, l.englishName;

-- Alle Übersetzungsvorschläge (Votes) für einen bestimmten Quelltext
SELECT lm.name AS model, l.englishName AS language, v.translatedText, v.submittedAt
FROM votes v
JOIN llm_models lm ON v.llmModelId = lm.id
JOIN languages l ON v.languageId = l.id
JOIN source_texts st ON v.sourceTextId = st.id
WHERE st.englishText = 'Hello, world!'
ORDER BY v.submittedAt DESC;

-- Anzahl Übersetzungen pro Modell
SELECT lm.name, COUNT(v.id) AS anzahl_uebersetzungen
FROM llm_models lm
LEFT JOIN votes v ON lm.id = v.llmModelId
GROUP BY lm.id, lm.name
ORDER BY anzahl_uebersetzungen DESC;
