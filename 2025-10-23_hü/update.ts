import { DatabaseSync } from "node:sqlite";

const db = new DatabaseSync("2ahwii.db");

const stmt = db.prepare("UPDATE students SET name = ? WHERE id = ?");

stmt.run("ghjhdfh", 55645);