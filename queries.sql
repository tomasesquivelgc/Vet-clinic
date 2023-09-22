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

-- Day 3

-- Who was the last animal seen by William Tatcher?
SELECT animals.name, vets.name, visits.date_of_visit
FROM animals
JOIN visits ON animals."ID" = visits.animals_id
JOIN vets ON vets.id = visits.vets_id
WHERE vets.name = 'William Tacher'
ORDER BY visits.date_of_visit DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animals."ID") AS animal_count
FROM animals
JOIN visits ON animals."ID" = visits.animals_id
JOIN vets ON vets.id = visits.vets_id
WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.*, species.name AS species_name
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vets_id
LEFT JOIN species ON species.id = specializations.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.*
FROM animals
JOIN visits ON animals."ID" = visits.animals_id
JOIN vets ON vets.id = visits.vets_id
WHERE vets.name = 'Stephanie Mendez'
AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT
    animals."ID" AS animal_id,
    animals.name AS animal_name,
    COUNT(*) AS visit_count
FROM
    visits
JOIN
    animals ON visits.animals_id = animals."ID"
GROUP BY
    animals."ID", animals.name
ORDER BY
    COUNT(*) DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT
    animals.name AS animal_name,
    visits.date_of_visit
FROM
    visits
JOIN    
    animals ON visits.animals_id = animals."ID"
JOIN
    vets ON visits.vets_id = vets.id
WHERE
    vets.name = 'Maisy Smith'
ORDER BY
    visits.date_of_visit ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT
    animals.name AS animal_name,
    vets.name AS vet_name,
    visits.date_of_visit
FROM
    visits
JOIN
    animals ON visits.animals_id = animals."ID"
JOIN
    vets ON visits.vets_id = vets.id
ORDER BY
    visits.date_of_visit DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(num_visits)
FROM (
  SELECT
  FROM visits
  INNER JOIN animals ON visits.animals_id = animals."ID"
  INNER JOIN vets ON vets_id = vets.id
  WHERE vets.id NOT IN (
    SELECT specializations.vets_id
    FROM specializations
    WHERE specializations.species_id = animals.species_id
) 
) AS num_visits;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT COUNT(animals.species_id) AS more_visits_from, species.name FROM visits 
INNER JOIN animals ON visits.animals_id = animals."ID"
INNER JOIN vets ON visits.vets_id = vets.id
INNER JOIN species ON animals.species_id = species.id
WHERE vets_id = 2
GROUP BY animals.species_id, species.name
ORDER BY more_visits_from DESC
LIMIT 1;