USE sakila;

-- CONTROLS --
-- 6 --
-- Primera opcion: si queremos que muestre apellidos que contengan solo Gibson o Gibson combinado con otros valores
SELECT
first_name AS Nombre,
last_name AS Apellido
FROM actor
WHERE last_name LIKE '%Gibson%';

-- Segunda opcion: si queremos que muestre apellidos que contengan solo Gibson - en este caso son equivalentes las dos opciones
SELECT
first_name AS Nombre,
last_name AS Apellido
FROM actor
WHERE last_name='Gibson';

-- 7 --
SELECT
first_name AS Nombre,
last_name AS Apellido,
actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 10 --
SELECT 
rental.customer_id AS ClienteID,
first_name AS NombreCliente,
last_name AS ApellidoCliente,
COUNT(DISTINCT rental.rental_id) AS RecuentoAlquileres
FROM rental
LEFT JOIN customer
	ON rental.customer_id = customer.customer_id
GROUP BY rental.customer_id
ORDER BY RecuentoAlquileres;

-- second control
SELECT 
customer_id
FROM customer
WHERE customer_id NOT IN (
	SELECT DISTINCT 
    customer_id
    FROM rental);

-- 11 --
SELECT DISTINCT
b.NombreCategoria,
COUNT(Distinct rental_id) AS RecuentoAlquileres
FROM (
	SELECT 
	a.FilmID,
	inventory.inventory_id,
	a.NombreCategoria
	FROM (
		SELECT
		film_category.film_id AS FilmID,
		category.category_id,
		category.name AS NombreCategoria
		FROM category
		LEFT JOIN film_category
			ON category.category_id = film_category.category_id) a
	LEFT JOIN inventory
		ON a.FilmID = inventory.film_id) b
RIGHT JOIN rental
	ON b.inventory_id = rental.inventory_id
GROUP BY NombreCategoria;

-- 13 --
SELECT
film_id
FROM film
WHERE title = 'Indian Love';

SELECT
actor_id
FROM film_actor
WHERE film_id = 458;

SELECT
first_name AS Nombre,
last_name AS Apellido
FROM actor
WHERE actor_id IN (2,8,38,77,81,107,135,149,176,177);

-- 14 --

SELECT
title AS Título
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

SELECT
title AS Título
FROM film
WHERE description LIKE '% dog %' OR description LIKE '% cat %'; -- mismo resultado que la anterior

SELECT
title AS Título
FROM film
WHERE description REGEXP '\\bdog\\b' OR description REGEXP '\\bcat\\b'; -- asegura que las apalabras dog y cat aparezcan como palabras aisladas \\b

-- 15 --
SELECT
title AS Titulo,
release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

SELECT
title AS Titulo,
release_year
FROM film
WHERE release_year = 2010;

-- 16 --
-- No parece haber ninguna pelicula llamada Family
SELECT
rating
FROM film
WHERE title = 'Family';

SELECT
title AS Titulo
FROM film
WHERE film_id IN (
	SELECT
	film_id
	FROM film_category
	WHERE category_id =(
		SELECT
		category_id
		FROM film_category
		WHERE film_id =(
			SELECT 
			film_id
			FROM film
			WHERE title = 'DOGMA FAMILY')));
            
SELECT
title AS Titulo,
film.film_id,
category_id
FROM film
LEFT JOIN film_category
	ON film.film_id = film_category.film_id
WHERE category_id = (
	SELECT
    category_id
    FROM film
    INNER JOIN film_category
		ON film.film_id = film_category.film_id
    WHERE title = 'DOGMA FAMILY'
);

-- 17 --
SELECT
title AS Titulo,
length
FROM film
WHERE rating = 'R' AND length > 120;

-- 18 --
SELECT
actor.first_name AS Nombre,
actor.last_name AS Apellido,
a.CantidadPeliculas
FROM actor
LEFT JOIN (
	SELECT
    actor_id,
    COUNT(DISTINCT film_id) AS CantidadPeliculas
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(DISTINCT film_id) >10
) a
	ON actor.actor_id = a.actor_id
ORDER BY a.CantidadPeliculas;

SELECT
actor.first_name AS Nombre,
actor.last_name AS Apellido,
a.CantidadPeliculas
FROM actor
RIGHT JOIN (
	SELECT
    actor_id,
    COUNT(DISTINCT film_id) AS CantidadPeliculas
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(DISTINCT film_id) <= 10
) a
	ON actor.actor_id = a.actor_id
ORDER BY a.CantidadPeliculas;

SELECT distinct actor_id FROM sakila.film_actor;

-- 20 --
SELECT
category.name AS Categoria,
ROUND(AVG(film.length)) AS DuracionPromedio
FROM film
INNER JOIN film_category
	ON film.film_id = film_category.film_id
INNER JOIN category
	ON film_category.category_id = category.category_id
GROUP BY category.category_id
-- HAVING DuracionPromedio >120
ORDER BY DuracionPromedio;

-- 22 --
SELECT
title AS Titulo,
MAX(TiempoAlquiler) AS TiempoMaximo 
FROM (
	SELECT
	DATEDIFF(return_date,rental_date) AS TiempoAlquiler,
	inventory.film_id AS film_id
	FROM rental
	LEFT JOIN inventory
		ON rental.inventory_id = inventory.inventory_id
	WHERE DATEDIFF(return_date,rental_date) > 4) a
INNER JOIN film
	ON a.film_id = film.film_id
GROUP BY film.film_id;

-- 23 --
SELECT
first_name AS Nombre,
last_name AS Apellido
FROM actor
WHERE actor_id NOT IN (
	SELECT DISTINCT
	actor_id
	FROM film_actor
	WHERE film_id IN (
		SELECT
		film_id
		FROM film_category
		WHERE category_id = (
			SELECT
			category_id
			FROm category
			WHERE name = 'Horror')));