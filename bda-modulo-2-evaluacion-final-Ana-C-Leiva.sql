USE sakila;

-- Ejercicio 1 --
-- restricción: todos los nombres de las peliculas sin duplicados - tabla film

SELECT DISTINCT 
title AS NombrePelicula
FROM film;

-- Ejercicio 2 --
-- restricción: nombre de todas las peliculas que tengan una clasificacion de "PG-13" - tabla film

SELECT
title AS NombrePelicula
FROM film
WHERE rating= "PG-13";

-- Ejercicio 3 --
-- mostrar titulo y descripcion
-- restricción: descripcion que contenga la palabra "amazing" - tabla film

SELECT
title AS Titulo,
description AS Descripcion
FROM film
WHERE description LIKE '%amazing%';

-- Ejercicio 4 --
-- mostrar titulo
-- restriccion que tenga duracion (length) mayor a 120 minutos - tabla film

SELECT
title AS Titulo
FROM film
WHERE length > 120;

-- Ejercicio 5 --
-- mostrar nombre (asumo que es nombre y apellido) agrego identificador
-- de todos los actores y actrices - tabla actor

SELECT
actor_id AS identificador,
first_name AS Nombre,
last_name AS Apellido
FROM actor;

-- Ejercicio 6 --
-- mostrar nombre y apellido
-- restriccion: que tengan 'Gibson' en su apellido - tabla actor

-- Si queremos que muestre apellidos que contengan solo Gibson o Gibson combinado con otros valores - control el mismo resultado que si imponogo = 'Gibson'
SELECT
first_name AS Nombre,
last_name AS Apellido
FROM actor
WHERE last_name LIKE '%Gibson%';

-- Ejercicio 7 --
-- mostrar nombre (asumo nombre y apellido)
-- restricción: actor_id entre 10 y 20 (asumo intervalo cerrado - incluyo los extremos) - tabla actor

SELECT
first_name AS Nombre,
last_name AS Apellido
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- Ejercicio 8 --
-- mostrar: titulo de la pelicula (title)
-- restricción: que no sean ni R ni PG-13 en su clasificación (rating) - tabla film

SELECT
title AS Titulo,
rating
FROM film
WHERE rating NOT IN ('R','PG-13');

-- Ejercicio 9 --
-- mostrar: recuento (COUNT(distinct title)) y clasificacion (rating) -- tabla film
-- control manual: la suma de las peliculas por categorias da el total de peliculas en la tabla film

SELECT
rating AS Clasificacion,
COUNT(DISTINCT film_id) AS RecuentoPelicuas
FROM film
GROUP BY rating;

-- Ejercicio 10 --
-- mostrar: recuento de alquileres por cliente (count distinct rent_id), id cliente, nombre y apellido -- tablas rental y customer
-- RIGHT JOIN: porque quiero quedarme con el recuento de los alquileres por cliente, incluso si no hubiese alquilado ninguna película
-- comprbando: hice con LEFT y RIGHT y da el mismo resultado. Segundo control: no existen customer_id que no pertenezcan a la tabla rental
	-- No existen clientes que no hayan alquilado

SELECT 
customer.customer_id AS ClienteID,
first_name AS NombreCliente,
last_name AS ApellidoCliente,
COUNT(DISTINCT rental_id) AS RecuentoAlquileres
FROM rental
RIGHT JOIN customer
	ON rental.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY RecuentoAlquileres;

-- Ejercicio 11 --
-- mostrar: Recuento de alquileres por categoría (COUNT(distinct rental_id)) y nombre categoria
-- CUATRO tablas: RENTAL (rental_id, film_id), INVENTORY (inventory_id, film_id), FILM_CATEGORY (film_id, category_id), CATEGORY (category_id, category_name)
-- control: suma por categoría igual al total de tabla rental

SELECT DISTINCT
category.name AS NombreCategoria,
COUNT(DISTINCT rental.rental_id) AS RecuentoAlquieleres
FROM rental
LEFT JOIN inventory
	ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film_category
	ON inventory.film_id = film_category.film_id
LEFT JOIN category
	ON film_category.category_id = category.category_id
GROUP BY NombreCategoria;

-- Ejercicio 12 --
-- mostrar: clasificación y duración promedio
-- tabla film
-- redondeo resultado de duración promedio para mejor visualización

SELECT
rating AS Clasificación,
ROUND(AVG(length)) AS DuracionPromedio
FROM film
GROUP BY rating;

-- Ejercicio 13 --
-- mostrar: nombre y apellido de actores de la pelicula Indian Love
-- 3 tablas: ACTOR (actor_id, first_name, last_name) FILM_ACTOR (film_id, actor_id) FILM (title, film_id) 

SELECT
first_name AS Nombre,
last_name AS Apellido
FROM actor
WHERE actor_id IN (
	SELECT
    actor_id
    FROM film_actor
    WHERE film_id = (
		SELECT
        film_id
        FROM film
        WHERE title = 'Indian Love'
    ));
    
-- Ejercicio 14 --
-- mostrar titulo de pelicula
-- restricción: palabras 'dog' o 'cat' en su descripción
-- REGEXP: asegura que las apalabras dog y cat aparezcan como palabras aisladas \\b


SELECT
title AS Titulo
FROM film
WHERE description REGEXP '\\bdog\\b' OR description REGEXP '\\bcat\\b'; 

-- Ejercicio 15 --
-- mostrar: titulo de peliculas
-- restricción: que hayan sido lanzadas entre el año 2005 y 2010 -- tabla film
-- control: solo parecen haber peliculas lanzadas en 2006

SELECT
title AS Titulo
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- Ejercicio 16 --
-- mostrar: titulo de peliculas
-- restricción: peliculas que pertenezcan a la misma categoría que Family - tablas film y film_category
-- No parece haber ninguna pelicula con el nombre 'Family' pero parece haber peliculas con la palabra family dentro
-- contro: corrí el codigo con un nombre de pelicula que si existe y funciona

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
			WHERE title = 'FAMILY')));
            
-- Ejercicio 17 -- 
-- mostrar: titulo de pelicula
-- restricción: rating = R y duración (length) > 120 minutos - tabla film

SELECT
title AS Titulo
FROM film
WHERE rating = 'R' AND length > 120;

-- ---------------------------------------------
-- BONUS --
-- ---------------------------------------------

-- Ejercicio 18 --
-- mostrar: nombre y appelido de actores
-- restricción: aparece en más de 10 películas - tablas actor y film_actor
-- control agregando a.CantidadPeliculas en SELECT - ok
-- RIGHT JOIN: porque quiero solo los nombres de los actores que cumplan con la condición - No hay actores con menos de 10 peliculas

SELECT
actor.first_name AS Nombre,
actor.last_name AS Apellido
FROM actor
RIGHT JOIN (
	SELECT
    actor_id,
    COUNT(DISTINCT film_id) AS CantidadPeliculas
    FROM film_actor
    GROUP BY actor_id
    HAVING  CantidadPeliculas > 10
) a
	ON actor.actor_id = a.actor_id
ORDER BY a.CantidadPeliculas;

-- Ejercicio 19 --
-- mostrar: cuantos actores (si hay) que no aparecen en ninguna pelicula
-- tablas: actor film_actor

SELECT
COUNT(DISTINCT actor_id)
FROM actor
WHERE actor_id NOT IN (
	SELECT DISTINCT 
    actor_id
    FROM film_actor
); -- NO hay ningún actor en la tabla actor que no esté en alguna película en la tabla film_actor

-- Ejercicio 20 --
-- mostrar: nombre de la categoría (category.name) y promedio duración (length)
-- restriccion: duración mayor a 120 minutos

SELECT
category.name AS Categoria,
ROUND(AVG(film.length)) AS DuracionPromedio
FROM film
INNER JOIN film_category
	ON film.film_id = film_category.film_id
INNER JOIN category
	ON film_category.category_id = category.category_id
GROUP BY category.category_id
HAVING DuracionPromedio >120;

-- Ejercicio 21 --
-- mostrar: nombre y apellido de actor, y cantidad de peliculas en las que ha actuado
-- restricción: haber actuado en almenos 5 películas - no hay actores con menos de 5 peliculas

SELECT
actor.first_name AS Nombre,
actor.last_name AS Apellido,
COUNT(DISTINCT film_id) AS CantidadPeliculas
FROM film_actor
LEFT JOIN actor
	ON film_actor.actor_id = actor.actor_id
GROUP BY film_actor.actor_id
HAVING CantidadPeliculas > 5;

-- Ejercicio 22 --
-- mostrar: Titulo de pelicula
-- restricción: haber sido alquilada por más de 5 días
-- requisito: utilizar subconsulta

SELECT
title AS Titulo
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

-- Ejercicio 23 --
-- mostrar: nombre y apellido de actores
-- restricción: no han actuado en pelicula de categoría 'Horror'
-- requisito: Sunconsulta para encontrar actores que han actuado en peliculas de horror -- 4 tablas

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
			FROM category
			WHERE name = 'Horror')));
            
-- Ejercicio 24 --
-- mostrar: titulo de pelicula (tabla film)
-- restriccion: categoria comedia (tablas category and film_category) y duración mayor a 180 minutos (tabla film)

SELECT
title AS Titulo
FROM film
WHERE film_id IN (
	SELECT
	film_id
	FROM film_category
	LEFT JOIN category
		ON film_category.category_id = category.category_id
	WHERE name = 'Comedy') 
AND length > 180;

-- Ejercicio 25 --
-- mostrar: actores - asumo que muestro Nombre, Apellido y actor_id
-- restriccion: que hayan actuado juntos al menos una vez
-- tablas actor y film_actor

SELECT
actor_id1,
tabla2.Nombre1 AS Nombre1,
tabla2.Apellido1 AS Apellido1,
actor_id2,
actor.first_name AS Nombre2,
actor.last_name AS Apellido2
FROM (
	SELECT
	actor_id1,
	actor.first_name AS Nombre1,
	actor.last_name AS Apellido1,
	actor_id2
	FROM (
		SELECT DISTINCT
		LEAST(a.actor_id, b.actor_id) AS actor_id1,
		GREATEST(a.actor_id, b.actor_id) AS actor_id2
		FROM film_actor AS a, film_actor AS b
		WHERE a.actor_id <> b.actor_id
		AND a.film_id = b.film_id) tabla1
	LEFT JOIN actor
		ON tabla1.actor_id1 = actor.actor_id) tabla2
LEFT JOIN actor 
	ON tabla2.actor_id2 = actor.actor_id;
