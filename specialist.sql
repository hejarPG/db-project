CREATE DOMAIN rating_type AS INT
    CHECK (VALUE BETWEEN 1 AND 5);

CREATE TYPE available_place_enum AS ENUM('customer', 'specialist', 'both');

CREATE TABLE specialist(
    id                  SERIAL          PRIMARY KEY,
    first_name          VARCHAR(100)    NOT NULL,
    last_name           VARCHAR(100)    NOT NULL,
    phone_number        VARCHAR(20)     UNIQUE NOT NULL,
    image_uri           TEXT,
    city_id             INT,
    location            POINT,
    operating_radius    SMALLINT        CHECK(operating_radius > 0),
    service_category_id INT,

    FOREIGN KEY (city_id)               REFERENCES city(id)     ON DELETE SET NULL,
    FOREIGN KEY (service_category_id)   REFERENCES category(id) ON DELETE SET NULL
);


CREATE TABLE specialist_service(
    service_id      INT NOT NULL,
    specialist_id   INT NOT NULL,
    avalable_at     available_place_enum,
    offered_price   DECIMAL(12, 2),

    PRIMARY KEY (service_id, specialist_id),
    FOREIGN KEY (service_id)    REFERENCES service(id)      ON DELETE CASCADE,
    FOREIGN KEY (specialist_id) REFERENCES specialist(id)   ON DELETE CASCADE
)