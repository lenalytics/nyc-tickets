-- creating Metabase DB first
CREATE DATABASE "metabase";
GRANT ALL PRIVILEGES ON DATABASE "metabase" TO "analyst";

BEGIN;
GRANT ALL PRIVILEGES ON DATABASE "tickets" TO "analyst";
CREATE TABLE "nyc_tickets"
(
    "summons_number"                    BIGINT NOT NULL,
    "plate_id"                          TEXT,
    "registration_state"                TEXT,
    "plate_type"                        TEXT,
    "issue_date"                        DATE,
    "violation_code"                    INTEGER,
    "vehicle_body_type"                 TEXT,
    "vehicle_make"                      TEXT,
    "issuing_agency"                    TEXT,
    "street_code_1"                     INTEGER,
    "street_code_2"                     INTEGER,
    "street_code_3"                     INTEGER,
    "vehicle_expiration_date"           TEXT,
    "violation_location"                TEXT,
    "violation_precinct"                INTEGER,
    "issuer_precinct"                   INTEGER,
    "issuer_code"                       INTEGER,
    "issuer_command"                    TEXT,
    "issuer_squad"                      TEXT,
    "violation_time"                    TEXT,
    "time_first_observed"               TEXT,
    "violation_county"                  TEXT,
    "violation_in_front_of_or_opposite" TEXT,
    "house_number"                      TEXT,
    "street_name"                       TEXT,
    "intersecting_street"               TEXT,
    "date_first_observed"               TEXT,
    "law_section"                       INTEGER,
    "sub_division"                      TEXT,
    "violation_legal_code"              TEXT,
    "days_parking_in_effect"            TEXT,
    "from_hours_in_effect"              TEXT,
    "to_hours_in_effect"                TEXT,
    "vehicle_color"                     TEXT,
    "unregistered_vehicle"              TEXT,
    "vehicle_year"                      INTEGER,
    "meter_number"                      TEXT,
    "feet_from_curb"                    DECIMAL,
    "violation_post_code"               TEXT,
    "violation_description"             TEXT,
    "no_standing_or_stopping_violation" TEXT,
    "hydrant_violation"                 TEXT,
    "double_parking_violation"          TEXT,
    "latitude"                          DECIMAL,
    "longitude"                         DECIMAL,
    "community_board"                   TEXT,
    "community_council"                 TEXT,
    "census_tract"                      TEXT,
    "bin"                               TEXT,
    "bbl"                               TEXT,
    "nta"                               TEXT,
    CONSTRAINT "PK_tickets" PRIMARY KEY ("summons_number")
);

CREATE INDEX "IDX_tickets_vehicle_make" ON "nyc_tickets" ("vehicle_make");
CREATE INDEX "IDX_tickets_issue_date" ON "nyc_tickets" ("issue_date");

COMMIT;

BEGIN;

CREATE TEMP TABLE "temp_tickets"
(
    LIKE "nyc_tickets"
) ON COMMIT DROP;

COPY "temp_tickets" FROM '/docker-entrypoint-initdb.d/year_2014.csv' DELIMITER ',' CSV HEADER;
COPY "temp_tickets" FROM '/docker-entrypoint-initdb.d/year_2015.csv' DELIMITER ',' CSV HEADER;
COPY "temp_tickets" FROM '/docker-entrypoint-initdb.d/year_2016.csv' DELIMITER ',' CSV HEADER;
COPY "temp_tickets" ("summons_number", "plate_id", "registration_state", "plate_type", "issue_date", "violation_code",
                     "vehicle_body_type", "vehicle_make", "issuing_agency", "street_code_1", "street_code_2",
                     "street_code_3", "vehicle_expiration_date", "violation_location", "violation_precinct",
                     "issuer_precinct", "issuer_code", "issuer_command", "issuer_squad", "violation_time",
                     "time_first_observed", "violation_county", "violation_in_front_of_or_opposite", "house_number",
                     "street_name", "intersecting_street", "date_first_observed", "law_section", "sub_division",
                     "violation_legal_code", "days_parking_in_effect", "from_hours_in_effect", "to_hours_in_effect",
                     "vehicle_color", "unregistered_vehicle", "vehicle_year", "meter_number", "feet_from_curb",
                     "violation_post_code", "violation_description", "no_standing_or_stopping_violation",
                     "hydrant_violation", "double_parking_violation")
    FROM '/docker-entrypoint-initdb.d/year_2017.csv' DELIMITER ',' CSV HEADER;

INSERT INTO "nyc_tickets"
SELECT *
FROM "temp_tickets"
ON CONFLICT DO NOTHING;

COMMIT;
