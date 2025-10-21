import { DatabaseSync } from "node:sqlite";

const db = new DatabaseSync("2ahwii.db");

let stmt = db.prepare("SELECT * FROM students");

const rows = stmt.all();
stmt = db.prepare("insert into students(id, name, birthdate) values (?, ?, ?)");

stmt.run(55645, "sdfs", "2323-12-23");
console.log(rows);