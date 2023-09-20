CREATE TABLE public.vet_clinic
(
    "ID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 ),
    name text NOT NULL,
    date_of_birth date NOT NULL,
    escape_attempts integer NOT NULL,
    neutered boolean NOT NULL,
    weight_kg numeric NOT NULL,
    species text,
    PRIMARY KEY ("ID")
);

ALTER TABLE IF EXISTS public.vet_clinic
    OWNER to postgres;