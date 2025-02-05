CREATE TABLE province(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    capital_id INT NOT NULL,
    location POINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE city(
    id          SERIAL          PRIMARY KEY,
    name        VARCHAR(255)    NOT NULL,
    province_id INT             NOT NULL,
    location                    POINT,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (province_id) REFERENCES province(id) ON DELETE CASCADE
)
