CREATE TABLE certificate(
    id                      SERIAL          PRIMARY KEY,
    title                   VARCHAR(255)    NOT NULL,
    description             TEXT,
    issued_by               VARCHAR(255),
    validity_period_in_year SMALLINT,
    background_uri          TEXT
);

CREATE TABLE specialist_service_certificate(
    
)