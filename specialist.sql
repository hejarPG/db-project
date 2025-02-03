CREATE DOMAIN rating_type AS INT
    CHECK (VALUE BETWEEN 1 AND 5);

CREATE TABLE specialist(
    id SERIAL PRIMARY KEY,
    first_name          VARCHAR(100)    NOT NULL,
    last_name           VARCHAR(100)    NOT NULL,
    phone_number        VARCHAR(20)     UNIQUE NOT NULL,
    image_uri           TEXT,
    location            POINT,
    operating_radius    SMALLINT        CHECK(operating_radius > 0),

);