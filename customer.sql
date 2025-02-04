CREATE TABLE customer(
    id              SERIAL          PRIMARY KEY,
    first_name      VARCHAR(255)    NOT NULL,
    last_name       VARCHAR(255)    NOT NULL,
    phone_number    VARCHAR(20)     UNIQUE NOT NULL,
    password        VARCHAR(72)     NOT NULL,
    city_id         INT,
    sex             sex_enum,
    birthdate       DATE,
    image_uri       TEXT,
    is_active       BOOLEAN         DEFAULT TRUE,
    created_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (city_id) REFERENCES city(id) ON DELETE SET NULL
);

