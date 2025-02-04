CREATE TABLE "order"(
    id              SERIAL      PRIMARY KEY,
    customer_id     INT,
    service_id      INT,
    specialist_id   INT,
    created_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id)   REFERENCES customer(id)     ON DELETE SET NULL,
    FOREIGN KEY (service_id)    REFERENCES service(id)      ON DELETE CASCADE,
    FOREIGN KEY (specialist_id) REFERENCES specialist(id)   ON DELETE SET NULL
);


CREATE TABLE offer(
    order_id                    INT,
    specialist_id               INT,
    price                       DECIMAL(12, 2),
    is_accepted_by_specialst    BOOLEAN     DEFAULT FALSE,
    created_at                  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at                  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (order_id, specialist_id),
    FOREIGN KEY (order_id)      REFERENCES "order"(id)        ON DELETE CASCADE,
    FOREIGN KEY (specialist_id) REFERENCES specialist(id)   ON DELETE CASCADE
);


CREATE DOMAIN rating_type AS INT CHECK (VALUE BETWEEN 1 AND 5);
CREATE TABLE rating(
    order_id        INT,
    specialist_id   INT,
    rating          rating_type,
    comment         TEXT,
    created_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (order_id, specialist_id),
    FOREIGN KEY (order_id)      REFERENCES "order"(id)      ON DELETE SET NULL,
    FOREIGN KEY (specialist_id) REFERENCES specialist(id) ON DELETE SET NULL
);


CREATE TABLE descriptive_asnwer(
    order_id INT,
    question_id INT,
    asnwer TEXT,
    is_nullable BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (order_id, question_id),
    FOREIGN KEY (order_id) REFERENCES "order"(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE
);

CREATE TABLE descriptive_asnwer(
    order_id    INT,
    question_id INT,
    asnwer      REAL,
    is_nullable BOOLEAN     DEFAULT FALSE,
    created_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (order_id, question_id),
    FOREIGN KEY (order_id)    REFERENCES "order"(id)      ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id)   ON DELETE CASCADE
);

CREATE TABLE multiple_choise_answer(
    order_id int,
    question_id int,
    choice_id int,
    created_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (order_id, question_id, choice_id),
    FOREIGN KEY (order_id) REFERENCES "order"(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE,
    FOREIGN KEY (choice_id) REFERENCES choice(id) ON DELETE CASCADE
)