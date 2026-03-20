# infi
CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE,
    country TEXT
);
Insert data
sql
Copy code
INSERT INTO customers (name, email, country)
VALUES ('Alice', 'alice@mail.com', 'Germany');
°alles was eine funktion bekommen soll bekommt namen der funktion, also keine Klammer, erst NACH aufgerufen klammer-->fetch1,then1
code kann anonym oder nicht anonym geschrieben werden, man benutzt beides,kommt darauf an was man macht(öfter aufrufen oder nicht)
°objekt von unterobjekt mit punkten getrennt
°in promise nur 1 mal promise mit 1 rejekt,resolve, sie die antwort 1 mal an then weiter gibt