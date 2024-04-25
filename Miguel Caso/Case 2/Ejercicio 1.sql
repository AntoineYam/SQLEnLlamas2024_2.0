/* Purgamos la tabla customer_orders */
WITH temp_customer_orders AS (
	SELECT order_id,
	customer_id,
	pizza_id,
	CASE exclusions
		WHEN 'beef' THEN '3'
		WHEN 'null' THEN ''
		ELSE COALESCE (EXCLUSIONS, '')
		END AS mod_exclusions,
	CASE extras
		WHEN 'null' THEN ''
		ELSE COALESCE (EXTRAS, '')
		END AS mod_extras,
	order_time
	FROM SQL_EN_LLAMAS_ALUMNOS.CASE02.CUSTOMER_ORDERS),

/* Purgamos la tabla runner_orders */
temp_runner_orders AS (
	SELECT order_id,
	runner_id,
	CASE pickup_time
		WHEN 'null' THEN ''
		ELSE pickup_time
		END AS mod_pickuptime,
	CAST(CASE
		WHEN distance='null' THEN ''
		WHEN PATINDEX('%[^1234567890.]%', duration) =0 THEN distance
		ELSE STUFF(distance, PATINDEX('%[^1234567890.]%', distance),10,'')
		END AS float) AS mod_distance,
	CAST (CASE
		WHEN PATINDEX('%[^1234567890.]%', duration)=0 THEN duration
		ELSE STUFF(duration, PATINDEX('%[^1234567890.]%', duration),10,'')
		END AS float) AS mod_duration,
	CASE CANCELLATION
		WHEN 'null' THEN ''
		ELSE COALESCE(CANCELLATION, '')
		END AS mod_cancellation
	FROM SQL_EN_LLAMAS_ALUMNOS.CASE02.RUNNER_ORDERS),

runner_stats AS (
        SELECT 
		ro.runner_id,
		COALESCE(ro.mod_distance, 0) AS mod_distance,
		COALESCE(ro.mod_duration, 0) AS mod_duration,
		ro.mod_distance/(ro.mod_duration/60) AS velocidad_media_kmh,
		COALESCE(ro.mod_cancellation,'') AS mod_cancellation
        FROM SQL_EN_LLAMAS_ALUMNOS.case02.runners r
		LEFT JOIN temp_runner_orders ro ON r.runner_id = ro.runner_id
	WHERE ro.mod_cancellation = ''
)

SELECT 
	r.runner_id,
	ROUND (COALESCE (SUM(rs.mod_distance),0),2) AS Distancia_acumulada,
	ROUND (COALESCE (AVG(rs.velocidad_media_kmh),0),2) AS Velocidad_Promedio_KMH
FROM SQL_EN_LLAMAS_ALUMNOS.CASE02.RUNNERS r
	LEFT JOIN runner_stats rs ON r.runner_id = rs.runner_id
GROUP BY r.runner_id
ORDER BY r.runner_id;
