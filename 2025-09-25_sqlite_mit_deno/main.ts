//sync adapter für sqlite
import { DatabaseSync } from "node:sqlite";

//konkreter "handle" für eine spezifische datenbank
const db = new DatabaseSync("2ahwii.db");

//statement wird zuerst "prepared" und dann "executed"
let stmt = db.prepare("SELECT * FROM students");
//hier das execute:
const rows = stmt.all();
stmt = db.prepare("insert into students(id, name, birthdate) values (?, ?, ?)");

stmt.run(33, "qrqwer", "2323-12-23");
console.log(rows);
//bei select * from students ist * dafür da, dass alles selected wird
//record ist zeile
