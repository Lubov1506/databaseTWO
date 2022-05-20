/* 1:1 */

CREATE TABLE "coach"(
    "id" serial PRIMARY KEY,
    "name" varchar(64) NOT NULL CHECK ("name" !='')
);

CREATE TABLE "team"(
    "id" serial PRIMARY KEY,
    "name" varchar(64) NOT NULL CHECK ("name" !=''),
    "coach_id" int REFERENCES "coach"("id")
);

ALTER TABLE "coach"
ADD COLUMN "team_id" int REFERENCES "team"("id");