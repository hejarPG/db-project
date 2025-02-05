CREATE TYPE sex_enum AS ENUM('male', 'female');

CREATE TABLE specialist(
    id                  SERIAL          PRIMARY KEY,
    first_name          VARCHAR(100)    NOT NULL,
    last_name           VARCHAR(100)    NOT NULL,
    phone_number        VARCHAR(30)     UNIQUE NOT NULL,
    sex                 sex_enum,
    image_uri           TEXT,
    city_id             INT,
    location            POINT,
    address             TEXT,
    operating_radius    SMALLINT        CHECK(operating_radius > 0),
    service_category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (city_id)               REFERENCES city(id)     ON DELETE SET NULL,
    FOREIGN KEY (service_category_id)   REFERENCES category(id) ON DELETE SET NULL
);


CREATE TABLE specialist_service(
    service_id      INT NOT NULL,
    specialist_id   INT NOT NULL,
    available_at     available_place_enum,
    offered_price   DECIMAL(12, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (service_id, specialist_id),
    FOREIGN KEY (service_id)    REFERENCES service(id)      ON DELETE CASCADE,
    FOREIGN KEY (specialist_id) REFERENCES specialist(id)   ON DELETE CASCADE
)
