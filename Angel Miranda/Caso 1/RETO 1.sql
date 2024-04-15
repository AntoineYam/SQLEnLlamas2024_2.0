SELECT	A.CUSTOMER_ID,
	SUM(COALESCE(C.PRICE,0)) AS TOTAL_GASTADO
FROM	CASE01.CUSTOMERS A
	LEFT OUTER JOIN CASE01.SALES B
		ON A.CUSTOMER_ID=B.CUSTOMER_ID
	LEFT OUTER JOIN CASE01.MENU C
		ON B.PRODUCT_ID=C.PRODUCT_ID
GROUP BY A.CUSTOMER_ID;
