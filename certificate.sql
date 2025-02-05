CREATE TABLE certificate(
    id                      SERIAL          PRIMARY KEY,
    title                   VARCHAR(255)    NOT NULL,
    description             TEXT,
    issued_by               VARCHAR(255),
    validity_period_in_year SMALLINT,
    background_uri          TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE service_certificate(
    service_id      INT,
    certificate_id  INT,
    is_required     BOOLEAN     DEFAULT FALSE,
    value           INT         CHECK (value BETWEEN 1 AND 5),
    created_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (service_id, certificate_id),
    FOREIGN KEY (service_id)        REFERENCES service(id),
    FOREIGN KEY (certificate_id)    REFERENCES certificate(id)
);


CREATE TABLE specialist_service_certificate(
    service_id      INT,
    specialist_id   INT,
    certificate_id  INT,
    is_certified    BOOLEAN,
    expires_in      DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (specialist_id, service_id, certificate_id),
    FOREIGN KEY (service_id, specialist_id) REFERENCES specialist_service(service_id, specialist_id) ON DELETE CASCADE,
    FOREIGN KEY (certificate_id)            REFERENCES certificate(id) ON DELETE CASCADE
)

-- select * from spe where specialist_id=1
-- drop table specialist_service_certificate
select * from specialist_service_certificate