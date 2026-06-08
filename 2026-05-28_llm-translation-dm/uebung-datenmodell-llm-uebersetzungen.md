# Übung: Datenmodell für LLM-Übersetzungen

## Beschreibung

Dieses Prisma-Datenmodell bildet ein System ab, in dem mehrere LLMs (Large Language Models) Übersetzungen für Texte in verschiedene Sprachen vorschlagen und bewerten können.

## Modelle

| Modell | Beschreibung |
|--------|-------------|
| `LlmModel` | Ein KI-Sprachmodell (z.B. GPT-4, Claude, Gemini) |
| `Language` | Eine Sprache mit BCP-47-, POSIX- und ISO-639-3-Codes |
| `SourceText` | Ein englischer Quelltext, der übersetzt werden soll |
| `LanguageProficiency` | Selbsteinschätzung eines LLMs für eine Sprache (1-10) |
| `Vote` | Ein Übersetzungsvorschlag eines LLMs für einen Text in eine Zielsprache |

## Beziehungen

- LLM : LanguageProficiency = 1:N (ein LLM beherrscht viele Sprachen)
- Language : LanguageProficiency = 1:N (eine Sprache wird von vielen LLMs beherrscht)
- LLM : Vote = 1:N (ein LLM macht viele Übersetzungsvorschläge)
- SourceText : Vote = 1:N (ein Text hat viele Übersetzungsvorschläge)
- Language : Vote = 1:N (eine Sprache hat viele Übersetzungsvorschläge)

## Besonderheiten

- Zusammengesetzter Unique-Constraint bei `LanguageProficiency`: (llmModelId, languageId) – jedes LLM hat genau eine Bewertung pro Sprache
- Zusammengesetzter Unique-Constraint bei `Vote`: (llmModelId, sourceTextId, languageId, translatedText) – verhindert doppelte Vorschläge
- Gezielte Indexes für häufige Abfragen (nach Sprache, nach Modell)
