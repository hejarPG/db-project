CREATE TABLE customer(
    id              SERIAL          PRIMARY KEY,
    first_name      VARCHAR(255)    NOT NULL,
    last_name       VARCHAR(255)    NOT NULL,
    phone_number    VARCHAR(35)     UNIQUE NOT NULL,
    password        VARCHAR(72)     NOT NULL,
    city_id         INT,
    location        Point,
    address         TEXT,
    sex             sex_enum,
    birthdate       DATE,
    image_uri       TEXT,
    is_active       BOOLEAN         DEFAULT TRUE,
    created_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (city_id) REFERENCES city(id) ON DELETE SET NULL
);

SELECT * from customer limit 10