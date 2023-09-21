SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = TRUE;
SELECT * FROM animals WHERE name <> 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Day 2

BEGIN;

UPDATE animals SET species = 'unspecified' WHERE species IS NULL OR species = '';

ROLLBACK;


BEGIN;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL OR species = '';

COMMIT;


BEGIN;

DELETE FROM animals;

ROLLBACK;


BEGIN;

-- Delete all animals born after Jan 1st, 2022
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- Create a savepoint for the transaction
SAVEPOINT weight_update_savepoint;

-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1;

-- Rollback to the savepoint
ROLLBACK TO SAVEPOINT weight_update_savepoint;

-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

-- Commit the transaction
COMMIT;

SELECT COUNT(*) AS animal_count FROM animals;

SELECT COUNT(*) AS animals_never_tried_to_escape_count
FROM animals
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) AS avg_weight FROM animals;

SELECT neutered, COUNT(*) AS escape_count
FROM animals
WHERE escape_attempts > 0
GROUP BY neutered
ORDER BY escape_count DESC;

SELECT
    species,
    MIN(weight_kg) AS min_weight,
    MAX(weight_kg) AS max_weight
FROM
    animals
GROUP BY
    species;

SELECT
    species,
    AVG(escape_attempts) AS avg_escape_attempts
FROM
    animals
WHERE
    date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY
    species;


-- Day 3

-- What animals belong to Melody Pond?
SELECT animals.*
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.*
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.*, animals.*
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

-- How many animals are there per species?
SELECT
    species.name AS species_name,
    COUNT(animals."ID") AS animal_count
FROM
    species
LEFT JOIN
    animals ON species.id = animals.species_id
GROUP BY
    species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT
    animals.*
FROM
    animals
JOIN
    owners ON animals.owner_id = owners.id
JOIN
    species ON animals.species_id = species.id
WHERE
    owners.full_name = 'Jennifer Orwell'
    AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT
    animals.*
FROM
    animals
JOIN
    owners ON animals.owner_id = owners.id
WHERE
    owners.full_name = 'Dean Winchester'
    AND animals.escape_attempts = 0;

-- Who owns the most animals?
SELECT
    owners.full_name,
    COUNT(animals."ID") AS animal_count
FROM
    owners
JOIN
    animals ON owners.id = animals.owner_id
GROUP BY
    owners.full_name
ORDER BY    
    animal_count DESC
LIMIT 1;
