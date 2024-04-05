--1 .Devuelve todas las películas
	SELECT * 
	FROM MOVIES
--2. Devuelve todos los géneros existentes
	SELECT * 
	FROM PUBLIC.GENRES 
--3. Devuelve la lista de todos los estudios de grabación que estén activos
	SELECT * 
		FROM PUBLIC.STUDIOS 
	WHERE STUDIO_ACTIVE =1
--4. Devuelve una lista de los 20 últimos miembros en anotarse al videoclub
	SELECT * FROM PUBLIC.MEMBERS 
		ORDER BY MEMBER_DISCHARGE_DATE 
	DESC LIMIT 20
--5. Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor.
	SELECT MOVIE_DURATION AS Duracion , COUNT(*) AS Frecuencia 
		FROM MOVIES 
			GROUP BY MOVIE_DURATION 
				ORDER BY Frecuencia DESC 
	LIMIT 20;
--6. Devuelve las películas del año 2000 en adelante que empiecen por la letra A.
	SELECT * FROM movies 
		WHERE MOVIE_LAUNCH_DATE >= '2000-01-01' AND MOVIE_NAME LIKE 'A%'
--7. Devuelve los actores nacidos un mes de Junio
	SELECT * FROM actors WHERE ACTOR_BIRTH_DATE LIKE '%%%%-06-%%'
--8. Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos.
	SELECT * FROM actors WHERE ACTOR_BIRTH_DATE NOT LIKE '%%%%-06-%%' AND ACTOR_DEAD_DATE IS null
--9. Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
SELECT
    DIRECTOR_NAME,
    AGE
FROM
    (
    SELECT
        DIRECTOR_NAME,
        DATEDIFF(YEAR, DIRECTOR_BIRTH_DATE, TODAY()) AS "AGE",
        DIRECTOR_DEAD_DATE
    FROM
        DIRECTORS)
WHERE
    AGE <= 50
    AND DIRECTOR_DEAD_DATE IS NULL

--10. Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
	SELECT
	ACTOR_NAME ,
	ACTOR_DEAD_DATE, 
	AGE
FROM
	(
	SELECT 
		ACTOR_NAME ,
		DATEDIFF(YEAR, ACTOR_BIRTH_DATE, TODAY()) AS "AGE",
		ACTOR_DEAD_DATE 
	FROM 
		ACTORS )
WHERE 
		AGE < 50
	AND ACTOR_DEAD_DATE IS NOT NULL
--11. Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT
		DIRECTOR_NAME
FROM
		DIRECTORS
WHERE
		DATEDIFF(YEAR, DIRECTOR_BIRTH_DATE, TODAY()) <= 40
	AND DIRECTOR_DEAD_DATE IS NULL

--12. Indica la edad media de los directores vivos
SELECT
	AVG(YEAR(NOW())-YEAR(DIRECTORS.DIRECTOR_BIRTH_DATE)) FROM DIRECTORS
	WHERE DIRECTORS.DIRECTOR_DEAD_DATE IS NULL

--13. Indica la edad media de los actores que han fallecido
SELECT
	AVG(YEAR(NOW())-YEAR(ACTORS.ACTOR_BIRTH_DATE))
FROM
	ACTORS
WHERE
	ACTORS.ACTOR_DEAD_DATE  IS NOT NULL
--14. Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT
	p.MOVIE_NAME ,
	e.STUDIO_NAME
FROM
	MOVIES p
JOIN STUDIOS e ON
	p.STUDIO_ID = e.STUDIO_ID ;

--15. Devuelve los miembros que alquilaron al menos una película entre el año 2010 y el 2015
SELECT
	*
FROM
	PUBLIC.MEMBERS m
WHERE
	MEMBER_ID IN (
	SELECT
		MR.MEMBER_ID
	FROM
		PUBLIC.MEMBERS_MOVIE_RENTAL MR
	WHERE
		YEAR(MR.MEMBER_RENTAL_DATE) BETWEEN 2010 AND 2015
);

--16. Devuelve cuantas películas hay de cada país
SELECT
	N.NATIONALITY_NAME,
	COUNT(pm.MOVIE_ID) AS MOVIE_COUNT
FROM
	PUBLIC.MOVIES pm
JOIN NATIONALITIES N ON
	N.NATIONALITY_ID = pm.NATIONALITY_ID
GROUP BY
	pm.NATIONALITY_ID,
	N.NATIONALITY_NAME;


--17. Devuelve todas las películas que hay de género documental
SELECT
	*
FROM
	movies m
WHERE
	m.GENRE_ID = (
	SELECT
		g.GENRE_ID
	FROM
		PUBLIC.GENRES g
	WHERE
		g.GENRE_NAME = 'Documentary'
);
--18. Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT
	m.*
FROM
	MOVIES m
JOIN DIRECTORS d ON
	m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE
	YEAR(d.DIRECTOR_BIRTH_DATE) >= 1980
	AND d.DIRECTOR_DEAD_DATE IS NULL;

--19. Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros del videoclub y los directores.
SELECT 
    M.MEMBER_NAME, 
    M.MEMBER_TOWN AS MEMBER_TOWN, 
    D.DIRECTOR_NAME, 
    D.DIRECTOR_BIRTH_PLACE 
FROM 
    MEMBERS M 
JOIN 
    DIRECTORS D 
ON 
    M.MEMBER_TOWN = D.DIRECTOR_BIRTH_PLACE;

--20. Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo
SELECT
	M.MOVIE_NAME,
	M.MOVIE_LAUNCH_DATE
FROM
	PUBLIC.MOVIES M
WHERE
	M.STUDIO_ID IN (
	SELECT
		STUDIO_ID
	FROM
		PUBLIC.STUDIOS E
	WHERE
		E.STUDIO_ACTIVE = 0
);

--21. Devuelve una lista de las últimas 10 películas que se han alquilado
SELECT
	M.*
FROM
	PUBLIC.PUBLIC.MOVIES m
WHERE
	M.MOVIE_ID IN(
	SELECT
		MMR.MOVIE_ID
	FROM
		PUBLIC.PUBLIC.MEMBERS_MOVIE_RENTAL mmr
	ORDER BY
		mmr.MEMBER_RENTAL_DATE DESC
	LIMIT 10
)
--22. Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT
    COUNT(*) N_PELICULAS,DIRECTOR_NAME
FROM
    (
    SELECT
        m.MOVIE_NAME ,
        m.MOVIE_LAUNCH_DATE ,
        d.DIRECTOR_BIRTH_DATE,
        DATEDIFF(YEAR, d.DIRECTOR_BIRTH_DATE, m.MOVIE_LAUNCH_DATE ) YEARS,
        d.DIRECTOR_ID,
        d.DIRECTOR_NAME 
    FROM
        MOVIES m
    JOIN DIRECTORS d ON
        d.DIRECTOR_ID = m.DIRECTOR_ID
    WHERE
        DATEDIFF(YEAR, d.DIRECTOR_BIRTH_DATE, m.MOVIE_LAUNCH_DATE ) < 41
) EDAD_PELICULAS
GROUP BY DIRECTOR_ID, DIRECTOR_NAME

--23. Indica cuál es la media de duración de las películas de cada director
SELECT 
    d.DIRECTOR_NAME,
    AVG(m.MOVIE_DURATION) AS DURACION_MEDIA
FROM 
    PUBLIC.DIRECTORS d
JOIN 
    PUBLIC.MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
GROUP BY 
    d.DIRECTOR_NAME;

--24. Indica cuál es el nombre y la duración mínima de la película que ha sido alquilada en los últimos 2 años por los miembros del videoclub (La "fecha de ejecución" en este script es el 25-01-2019)

SELECT 
    M.MOVIE_NAME,
    M.MOVIE_DURATION
FROM 
    PUBLIC.MOVIES M
JOIN 
    PUBLIC.MEMBERS_MOVIE_RENTAL MMR ON M.MOVIE_ID  = MMR.MOVIE_ID 
WHERE 
    YEAR(MMR.MEMBER_RENTAL_DATE) >= YEAR(DATEADD(YEAR, -2, DATE '2019-01-25'))
ORDER BY 
    MMR.MEMBER_RENTAL_DATE DESC
LIMIT 1;

--25. Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra "The" en cualquier parte del título
SELECT
	COUNT(*) AS NUMPEL,
	D.DIRECTOR_NAME 
FROM
	PUBLIC.MOVIES M
	JOIN 
	PUBLIC.DIRECTORS D
	ON
	d.DIRECTOR_ID =M.DIRECTOR_ID 
WHERE
	YEAR(M.MOVIE_LAUNCH_DATE) BETWEEN 1960 AND 1989
	AND
            UPPER(M.MOVIE_NAME) LIKE '%THE%'
GROUP BY
	D.DIRECTOR_ID;

--26. Lista nombre, nacionalidad y director de todas las películas
SELECT 
    M.MOVIE_NAME ,
    N.NATIONALITY_NAME ,
    D.DIRECTOR_NAME 
FROM 
    PUBLIC.MOVIES M
JOIN 
    PUBLIC.NATIONALITIES N ON M.NATIONALITY_ID = N.NATIONALITY_ID
JOIN 
    PUBLIC.DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID;

--27. Muestra las películas con los actores que han participado en cada una de ellas
SELECT 
    M.MOVIE_NAME 
    ,
    STRING_AGG(A.ACTOR_NAME, ', ') AS "Actores"
FROM 
    PUBLIC.MOVIES M
JOIN 
    PUBLIC.MOVIES_ACTORS MA ON M.MOVIE_ID = MA.MOVIE_ID
JOIN 
    PUBLIC.ACTORS A ON MA.ACTOR_ID = A.ACTOR_ID
GROUP BY 
    M.MOVIE_NAME
ORDER BY 
    M.MOVIE_NAME;
--28. Indica cual es el nombre del director del que más películas se han alquilado
SELECT
	MMR.MOVIE_ID,
	D.DIRECTOR_NAME,
	COUNT(*) AS num
FROM
	PUBLIC.MEMBERS_MOVIE_RENTAL MMR
JOIN 
    PUBLIC.MOVIES M ON
	MMR.MOVIE_ID = M.MOVIE_ID
JOIN 
    PUBLIC.DIRECTORS D ON
	M.DIRECTOR_ID = D.DIRECTOR_ID
GROUP BY
	MMR.MOVIE_ID,
	D.DIRECTOR_NAME
HAVING
	COUNT(*) = (
	SELECT
		MAX(cnt)
	FROM
		(
		SELECT
			COUNT(*) AS cnt
		FROM
			PUBLIC.MEMBERS_MOVIE_RENTAL
		GROUP BY
			MOVIE_ID) AS counts)
--29. Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT
	S.STUDIO_ID,
	S.STUDIO_NAME,
	COUNT(A.AWARD_ID) AS "PREMIOS"
FROM
	PUBLIC.STUDIOS S
JOIN
    PUBLIC.MOVIES M ON
	S.STUDIO_ID = M.STUDIO_ID
JOIN
    PUBLIC.AWARDS A ON
	M.MOVIE_ID = A.MOVIE_ID
GROUP BY
	S.STUDIO_ID,
	S.STUDIO_NAME
ORDER BY
	S.STUDIO_ID;
--30. Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)
SELECT
	MA.ACTOR_ID,
	A.ACTOR_NAME,
	COUNT(DISTINCT AW.AWARD_ID) AS "Nominaciones"
FROM
	PUBLIC.MOVIES_ACTORS MA
JOIN
    PUBLIC.AWARDS AW ON
	MA.MOVIE_ID = AW.MOVIE_ID
JOIN
    PUBLIC.ACTORS A ON
	MA.ACTOR_ID = A.ACTOR_ID
WHERE
	AW.AWARD_WIN = 0
GROUP BY
	MA.ACTOR_ID,
	A.ACTOR_NAME;
--31. Indica cuantos actores y directores hicieron películas para los estudios no activos
SELECT
	S.STUDIO_NAME,
	COUNT(DISTINCT MA.ACTOR_ID) AS "Cantidad de actores",
	COUNT(DISTINCT M.DIRECTOR_ID) AS "Cantidad de directores"
FROM
	PUBLIC.MOVIES M
JOIN
    PUBLIC.STUDIOS S ON
	M.STUDIO_ID = S.STUDIO_ID
JOIN
    PUBLIC.MOVIES_ACTORS MA ON
	M.MOVIE_ID = MA.MOVIE_ID
WHERE
	S.STUDIO_ACTIVE = 0
GROUP BY
	S.STUDIO_NAME;

--32. Indica el nombre, ciudad, y teléfono de todos los miembros del videoclub que hayan alquilado películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50
	SELECT
	ME.MEMBER_NAME,
	ME.MEMBER_TOWN,
	ME.MEMBER_PHONE
FROM
	PUBLIC.MEMBERS ME
JOIN 
    PUBLIC.MEMBERS_MOVIE_RENTAL MR ON
	ME.MEMBER_ID = MR.MEMBER_ID
JOIN 
    PUBLIC.MOVIES M ON
	MR.MOVIE_ID = M.MOVIE_ID
JOIN 
    PUBLIC.AWARDS AW ON
	M.MOVIE_ID = AW.MOVIE_ID
WHERE
	AW.AWARD_WIN < 50
	AND AW.AWARD_NOMINATION > 150
--33. Comprueba si hay errores en la BD entre las películas y directores (un director fallecido en el 76 no puede dirigir una película en el 88)
SELECT
    M.MOVIE_NAME,
    M.MOVIE_LAUNCH_DATE,
    M.DIRECTOR_ID,
    D.DIRECTOR_NAME,
    D.DIRECTOR_DEAD_DATE
FROM
    PUBLIC.MOVIES M
JOIN
    PUBLIC.DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
WHERE
    YEAR(M.MOVIE_LAUNCH_DATE) > YEAR(D.DIRECTOR_DEAD_DATE)
    AND D.DIRECTOR_DEAD_DATE IS NOT NULL;

--34. Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)
UPDATE PUBLIC.DIRECTORS
SET DIRECTOR_DEAD_DATE = DATEADD('YEAR', 1, (
    SELECT M.MOVIE_LAUNCH_DATE FROM PUBLIC.MOVIES M WHERE M.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
))
WHERE DIRECTOR_ID IN (
    SELECT
        M.DIRECTOR_ID
    FROM
        PUBLIC.MOVIES M
    JOIN
        PUBLIC.DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
    WHERE
        YEAR(M.MOVIE_LAUNCH_DATE) > YEAR(
            (SELECT DIRECTOR_DEAD_DATE FROM PUBLIC.DIRECTORS WHERE DIRECTOR_ID = M.DIRECTOR_ID)
        )
        AND D.DIRECTOR_DEAD_DATE IS NOT NULL
);
--35. Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película
SELECT 
    d.DIRECTOR_NAME,
    g.GENRE_NAME AS FAVORITE_GENRE,
    COUNT(*) AS C
FROM 
    PUBLIC.DIRECTORS d
JOIN 
    PUBLIC.MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
JOIN 
    PUBLIC.GENRES g ON m.GENRE_ID = g.GENRE_ID
GROUP BY 
    d.DIRECTOR_NAME,
    g.GENRE_NAME
HAVING 
    COUNT(*) = (
        SELECT 
            MAX(movie_count)
        FROM (
            SELECT 
                d.DIRECTOR_NAME,
                COUNT(*) AS movie_count
            FROM 
                PUBLIC.DIRECTORS d
            JOIN 
                PUBLIC.MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
            GROUP BY 
                d.DIRECTOR_NAME
        ) AS director_counts
        WHERE 
            director_counts.DIRECTOR_NAME = d.DIRECTOR_NAME
    );
--36. Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas

--37. Indica cuál fue la primera película que alquilaron los miembros del videoclub cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad
