-- Active: 1700416325724@@127.0.0.1@5432@db_hw
CREATE TABLE Notes (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Note TEXT NOT NULL UNIQUE,
    TimeOfCreation DATETIME NOT NULL,
    ProgressMade REAL DEFAULT 0 CHECK (ProgressMade BETWEEN 0 AND 1),
    Status TEXT DEFAULT 'started' CHECK (Status IN ('started', 'accepted', 'canceled'))
);

CONSTRAINT fk_customer FOREIGN KEY(customer_id) REFERENCES customers(customer_id)


CREATE TABLE contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    CONSTRAINT fk_customer FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE email (
    address TEXT,
    contact_id INTEGER,
    CONSTRAINT fk_email_contact FOREIGN KEY(contact_id) REFERENCES contacts(id)
);

CREATE TABLE phones (
    number TEXT,
    contact_id INTEGER,
    CONSTRAINT fk_phone_contact FOREIGN KEY(contact_id) REFERENCES contacts(id)
);