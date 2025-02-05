CREATE TYPE status_enum AS ENUM('finding specialist', 'in progress', 'finished', 'canceled');

CREATE TABLE "order"(
    id              SERIAL      PRIMARY KEY,
    customer_id     INT,
    service_id      INT,
    specialist_id   INT,
    status          status_enum DEFAULT 'finding specialist',
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

