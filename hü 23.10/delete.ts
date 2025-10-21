import { DatabaseSync } from "node:sqlite";

const db = new DatabaseSync("2ahwii.db");

const stmt = db.prepare("DELETE FROM students WHERE id = ?");

stmt.run(555);