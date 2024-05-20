WITH CUSTOMER_NODES_V2 AS ( --CREO UNA TABLA QUE ME INDIQUE SI EL CLIENTE HA CAMBIADO O NO REALMENTE DE NODO
SELECT 
	CUSTOMER_ID,
	NODE_ID,
	START_DATE,
	END_DATE,
	DATEDIFF(DAY,START_DATE,END_DATE) AS DIAS_DIFERENCIA,
	CASE WHEN LAG(NODE_ID, 1,0) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) = NODE_ID THEN 0 ELSE 1 END AS CAMBIA_NODO
FROM CASE03.CUSTOMER_NODES),

TABLA_DIMENSION_NODO AS ( --CREO TABLA EN LA QUE SE DIMENSIONAN LOS DÍAS QUE UN CLIENTE ESTÁ EN UN NODO
SELECT 
	CUSTOMER_ID,
	NODE_ID,
	START_DATE,
	END_DATE,
	CASE WHEN CAMBIA_NODO=0 THEN DIAS_DIFERENCIA + 1 ELSE DIAS_DIFERENCIA END AS DIAS_DIFERENCIA,
	SUM(CAMBIA_NODO) OVER (ORDER BY  CUSTOMER_ID,START_DATE) DIMENSION_CAMBIA_NODO
FROM CUSTOMER_NODES_V2)

SELECT 
	ROUND(AVG(CAST(DIAS AS FLOAT)),2) AS DIAS_MEDIA_POR_NODO
FROM(
	SELECT 
		DIMENSION_CAMBIA_NODO,
		CASE WHEN SUM(DIAS_DIFERENCIA)>100000 THEN NULL ELSE SUM(DIAS_DIFERENCIA) END AS DIAS
	FROM TABLA_DIMENSION_NODO
	GROUP BY DIMENSION_CAMBIA_NODO) AUXILIAR;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Bien resuelto! Había que darle al coco para usar los LAGs, días de diferencias y tal. Enhorabuena!!

*/
