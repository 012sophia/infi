import { DatabaseSync } from "node:sqlite";

const db = new DatabaseSync("2ahwii.db");

const stmt = db.prepare("SELECT * FROM students where id = ?");
console.log(stmt.get(55645));