//import { DatabaseSync } from "node:sqlite";

//const db = new DatabaseSync("2ahwii.db");
//const stmt = db.prepare("SELECT * FROM students");
//const rows = stmt.all();
//console.log(rows);

// main.ts
import { DB } from "https://deno.land/x/sqlite/mod.ts";

// Deno-Äquivalent zu: new DatabaseSync("2ahwii.db")
const db = new DB("2ahwii.db");



// Beispiel: Einfügen
db.query("INSERT INTO students (name, age, email) VALUES (32, aa, 2387-23-23)");

// Deno-Äquivalent zu: const rows = stmt.all();
const rows = db.query("SELECT * FROM students");

console.log("Alle Students:");
for (const [id, name, age, email] of rows) {
  console.log({ id, name, age, email });
}

db.close();