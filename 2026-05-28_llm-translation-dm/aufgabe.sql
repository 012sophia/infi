// Database configuration for SQLite
datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}

// Prisma Client for Deno runtime
generator client {
  provider = "prisma-client-js"
  runtime  = "deno"
}

// Language model (e.g., GPT-4, Claude 4, Gemini 3.1 Pro)
model LlmModel {
  id                  Int                  @id @default(autoincrement())
  name                String               @unique
  proficiencies      LanguageProficiency[]
  votes              Vote[]
  createdAt          DateTime             @default(now())

  @@map("llm_models")
}

// Language with multiple language codes and metadata
model Language {
  id                  Int                  @id @default(autoincrement())
  bcp47Code           String               @unique // e.g., "de", "en-US", "zh-Hans-CN"
  posixCode           String               @unique // e.g., "de_AT", "fr_FR"
  iso639_3Code        String               @unique // e.g., "deu", "eng", "cmn"
  directoryName       String               @unique // e.g., "values-de", "values-zh-rCN"
  englishName         String               // e.g., "German", "Chinese"
  whisperCode         String?              // Optional, for speech recognition
  proficiencies      LanguageProficiency[]
  votes              Vote[]
  createdAt          DateTime             @default(now())

  @@map("languages")
}

// Master strings (English source texts to be translated)
model SourceText {
  id                  Int                  @id @default(autoincrement())
  englishText         String               @unique
  votes              Vote[]
  createdAt          DateTime             @default(now())

  @@map("source_texts")
}

// Language proficiency: Each LLM rates its ability for each language (1-10)
model LanguageProficiency {
  id                  Int                  @id @default(autoincrement())
  llmModelId          Int
  languageId          Int
  proficiencyLevel    Int                  // 1-10 scale
  llmModel            LlmModel             @relation(fields: [llmModelId], references: [id], onDelete: Cascade)
  language            Language             @relation(fields: [languageId], references: [id], onDelete: Cascade)
  createdAt          DateTime             @default(now())

  @@unique([llmModelId, languageId])
  @@index([llmModelId])
  @@index([languageId])
  @@map("language_proficiencies")
}

// Vote: Translation proposal from an LLM for a source text in a target language
model Vote {
  id                  Int                  @id @default(autoincrement())
  llmModelId          Int
  sourceTextId        Int
  languageId          Int
  translatedText      String               // The proposed translation
  submittedAt        DateTime             @default(now())
  llmModel            LlmModel             @relation(fields: [llmModelId], references: [id], onDelete: Cascade)
  sourceText          SourceText           @relation(fields: [sourceTextId], references: [id], onDelete: Cascade)
  language            Language             @relation(fields: [languageId], references: [id], onDelete: Cascade)

  @@unique([llmModelId, sourceTextId, languageId, translatedText])
  @@index([languageId])
  @@index([llmModelId])
  @@index([llmModelId, languageId])
  @@map("votes")
}