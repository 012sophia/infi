import { DatabaseSync } from "node:sqlite";

const db = new DatabaseSync("2ahwii.db");

db.exec("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT NOT NULL, birthdate TEXT)");

const insertStmt = db.prepare("INSERT INTO students (id, name, birthdate) VALUES (?, ?, ?)");
insertStmt.run(1, "Sophia", "2008-05-12");
insertStmt.run(2, "Max", "2007-11-03");
insertStmt.run(3, "Anna", "2008-02-28");

const selectStmt = db.prepare("SELECT * FROM students");
const rows = selectStmt.all();
console.log("Alle Schüler:");
console.log(rows);
