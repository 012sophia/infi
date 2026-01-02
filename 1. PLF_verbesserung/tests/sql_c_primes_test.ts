import { assertEquals } from "@std/assert";
import * as sqlite from "@db/sqlite";

const dbname = "primes.db";
const db = new sqlite.Database(dbname);

function checkSql(sql: string, filename: string) {
    if (!sql) {
        throw new Error(`${filename} ist leer`);
    }
    if (!sqlite.isComplete(sql)) {
        throw new Error(`${filename} enthält fehlerhaftes sql`);
    }
}

function _getResult(tc: Deno.TestContext) {
    const sql = Deno.readTextFileSync(tc.name);
    checkSql(sql, tc.name);
    const stmt = db.prepare(sql);
    return stmt.all();
}

function _runFile(tc: Deno.TestContext) {
    const sql = Deno.readTextFileSync(tc.name);
    checkSql(sql, tc.name);
    db.exec(sql);
}

Deno.test("k.sql", (tc) => {
    const answer = [{ id: 521 }, { id: 569 }, { id: 599 }];
    assertEquals(_getResult(tc), answer);
});
