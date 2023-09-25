CREATE TABLE public.vet_clinic
(
    "ID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 ),
    name text NOT NULL,
    date_of_birth date NOT NULL,
    escape_attempts integer NOT NULL,
    neutered boolean NOT NULL,
    weight_kg numeric NOT NULL,
    PRIMARY KEY ("ID")
);

ALTER TABLE IF EXISTS public.vet_clinic
    OWNER to postgres;

-- Create a mew species column

ALTER TABLE IF EXISTS public.animals
    ADD COLUMN species text;

-- create owner table
CREATE TABLE public.owners
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 ),
    full_name text NOT NULL,
    age integer NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.owners
    OWNER to postgres;

-- create species table
CREATE TABLE public.species
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 ),
    name text NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.species
    OWNER to postgres;

-- delete species column from animals table
ALTER TABLE animals
DROP COLUMN species;

-- create a new table called species_id
ALTER TABLE IF EXISTS public.animals
    ADD COLUMN species_id integer;

-- add foreign key to species_id
ALTER TABLE public.animals
ADD CONSTRAINT fk_species_id
    FOREIGN KEY (species_id)
    REFERENCES public.species (id);

-- create a new column called owner_id
ALTER TABLE IF EXISTS public.animals
    ADD COLUMN owner_id integer;

-- add foreign key to owner_id
ALTER TABLE public.animals
ADD CONSTRAINT fk_owner_id
    FOREIGN KEY (owner_id)
    REFERENCES public.owners (id);
    
-- Day 3

-- create vets table
CREATE TABLE public.vets
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 ),
    full_name text NOT NULL,
    age integer NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.vets
    OWNER to postgres;

-- create specializations table
CREATE TABLE specializations (
species_id INT NOT NULL,
vets_id INT NOT NULL,
PRIMARY KEY (species_id, vets_id),
FOREIGN KEY (species_id) REFERENCES species(id),
FOREIGN KEY (vets_id) REFERENCES vets(id)
);

-- create visits table
CREATE TABLE visits (
    animals_id INT NOT NULL,
    vets_id INT NOT NULL,
    date_of_visit DATE NOT NULL,
    PRIMARY KEY (animals_id, vets_id, date_of_visit),
    FOREIGN KEY (animals_id) REFERENCES public.animals ("ID"),
    FOREIGN KEY (vets_id) REFERENCES public.vets (id)
);

CREATE INDEX animal_id_index ON visits(animals_id);
CREATE INDEX vet_id_index ON visits(vets_id);
ALTER TABLE owners
Add COLUMN email;
CREATE INDEX email_index ON owners(email);

CREATE INDEX visits_vet_id_covering_idx ON visits(vet_id) INCLUDE (id, animals_id, date_of_visit);