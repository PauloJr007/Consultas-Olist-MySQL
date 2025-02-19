USE olist;

-- 1. Quantos pedidos foram feitos?

SELECT 
	COUNT(DISTINCT(order_id))
FROM 
	olist_orders;
-- Foram feitos 96461 pedidos.


-- 2. Qual é o total de vendas (valor)?  

SELECT 
	SUM(payment_value)
FROM 
	olist_order_payments;
-- A receita obtida foi de 15.4 Milhões de Reais.


-- 3. Quantos clientes únicos realizaram pelo menos uma compra? 

SELECT 
	COUNT(DISTINCT(customer_unique_id))
FROM 
	olist_customers;
-- Existem 96096 clientes únicos registrados.
 
 
-- 4. Qual foi o mês com o maior volume de pedidos?  

SELECT 
    YEAR(order_purchase_timestamp) AS ano,
    MONTH(order_purchase_timestamp) AS mes,
    COUNT(order_id) AS total_pedidos
FROM 
	olist_orders
GROUP BY ano, mes
ORDER BY total_pedidos DESC
LIMIT 1;
-- O mês com maior volume de pedidos foi Novembro de 2017 (11/2017), com um total de 7288 pedidos.


-- 5. Quais são as cinco categorias de produtos mais vendidas em quantidade de itens?  

SELECT 
    p.product_category_name AS categoria,
    COUNT(oi.order_item_id) AS total_itens_vendidos
FROM 
	olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_itens_vendidos DESC
LIMIT 5;
-- As cinco categorias mais vendidas são:
	/*
    1- cama_mesa_banho = 10952
    2- beleza_saude = 9467
    3- esporte_lazer = 8429
    4- moveis_decoracao = 8156
    5- informatica_acessorios = 7643
    */


-- 6. Qual é o ticket médio por pedido? 

SELECT 
	AVG(payment_value)
FROM 
	olist_order_payments;
-- O ticket médio por pedido é de 153R$

 
-- 7. Qual foi o tempo médio de entrega dos pedidos?

SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS tempo_medio_entrega
FROM 
	olist_orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;
-- O tempo médio de entrega dos pedidos é de 12 dias.


-- 8. Quantos pedidos foram entregues com atraso?  

SELECT 
	COUNT(order_id) AS pedidos_com_atraso
FROM 
	olist_orders
WHERE order_estimated_delivery_date < order_delivered_customer_date
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL;
-- 7826 pedidos foram entregue com atraso. 


-- 9. Qual o número médio de produtos por pedido?  

SELECT 
    AVG(itens_por_pedido) AS media_produtos_por_pedido
FROM (
    SELECT 
        order_id,
        COUNT(order_item_id) AS itens_por_pedido
    FROM olist_order_items
    GROUP BY order_id
) AS subquery;
-- 1 Produto apenas (média = 1.14).


-- 10. Qual é o estado com o maior número de pedidos? 

SELECT 
	oc.customer_state AS estados,
    COUNT(o.order_id) AS total_pedidos
FROM 
	olist_orders o
JOIN olist_customers oc ON o.customer_id = oc.customer_id
GROUP BY oc.customer_state
ORDER BY total_pedidos DESC;
-- O Estado com maior número de pedidos é São Paulo, com 40.489 pedidos.

 
-- 11. Qual é a média de avaliação dos pedidos?  

SELECT 
	AVG(review_score)
FROM 
	olist_order_reviews;
-- A média de Avaliação dos Pedidos é de 4,08.


-- 12. Quantos pedidos tiveram avaliação menor ou igual a 3 estrelas?  

SELECT 
	COUNT(order_id)
FROM 
	olist_order_reviews
WHERE review_score <= 3;
-- 68 Pedidos tiveram avaliação menor ou igual a 3. 


-- 13. Qual foi a categoria de produto mais vendida em valor total de vendas?  

SELECT
	p.product_category_name AS categoria,
    SUM(oi.price) AS valor_total
FROM 
	olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id 
GROUP BY categoria
ORDER BY valor_total DESC
LIMIT 1;
-- A categoria mais vendida em valor é a "beleza_saude", tende gerado R$1.2 milhões


-- 14. Qual foi o vendedor com o maior número de pedidos?

SELECT
	seller_id,
	COUNT(order_id) AS pedidos
FROM 
	olist_order_items
GROUP BY seller_id
ORDER BY pedidos DESC;
-- O vendedor de id: '6560211a19b47992c3666cc44a7e94c0', foi o com maior número de pedidos, totalizando 1996 pedidos.


-- 15. Quais foram os cinco produtos mais vendidos em quantidade de unidades?  

SELECT
	product_id,
    COUNT(order_id) AS quantidade_vendida
FROM
	olist_order_items
GROUP BY product_id
ORDER BY quantidade_vendida DESC
LIMIT 5;
-- **Não existe o real nome dos produtos na base de dados, por isso será usado o product_id que é o identificador dos produtos.**
-- Os cinco produtos mais vendidos em quantidade de unidades foram:
	/*'aca2eb7d00ea1a7b8ebd4e68314663af': 520
	'422879e10f46682990de24d770e7f83d': 484
	'99a4788cb24856965c36a24e339b6058: 477
	'389d119b48cf3043d311335e499d9c6b: 390
	'368c6c730842d78016ad823897a372db: 388 */


-- 16. Qual foi o mês com o maior faturamento total? 

SELECT 
    YEAR(shipping_limit_date) AS ano,
    MONTH(shipping_limit_date) AS mes,
    SUM(price) AS faturamento
FROM 
	olist_order_items
GROUP BY ano, mes
ORDER BY faturamento DESC
LIMIT 1;
-- O mês com maior faturamento foi em Maio de 2018 (05/2018), com um faturamento de R$1.06 milhões.

 
-- 17. Quantos pedidos foram cancelados? 

SELECT
	COUNT(order_id)
FROM
	olist_orders
WHERE order_status = "canceled";
-- Apenas 6 pedidos foram cancelados.


-- 18. Qual é o tempo médio entre a compra e a aprovação do pagamento?  

SELECT 
    AVG(TIMESTAMPDIFF(hour, order_purchase_timestamp, order_approved_at)) AS tempo_medio_horas
FROM 
    olist_orders
WHERE order_status = "delivered";
-- O tempo médio em horas entre a compra e a aprovação do pagamento é de aproximadamente 10 horas.


-- 19. Quantos pedidos tiveram frete grátis?  

SELECT
	COUNT(order_id)
FROM 
	olist_order_items
WHERE freight_value = 0;
-- 381 pedidos tiveram frete grátis.


-- 20. Qual o valor médio do frete cobrado por pedido?  

SELECT 
	AVG(freight_value)
FROM 
	olist_order_items;
-- O valor médio do Frete é de R$19,94.


-- 21. Quantos pedidos foram feitos por clientes que já haviam comprado anteriormente?  

SELECT 
	COUNT(o.order_id) AS total_pedidos_repetidos
FROM 
	olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
WHERE c.customer_unique_id IN (
    SELECT 
		customer_unique_id
    FROM 
		olist_orders o2
    JOIN olist_customers c2 ON o2.customer_id = c2.customer_id
    GROUP BY c2.customer_unique_id
    HAVING COUNT(o2.order_id) > 1
);
-- Foram feitos 5919 pedidos por clientes que já haviam comprado anteriormente.


-- 22. Qual foi o maior valor de compra realizado por um único pedido?  

SELECT 
    MAX(payment_value)
FROM 
    olist_order_payments;
-- O maior valor de compra em um único pedido foi de R$13.664,08.


-- 23. Qual é o percentual de pedidos pagos via boleto bancário?  

SELECT 
    ROUND(AVG(CASE WHEN payment_type = 'boleto' THEN 1 ELSE 0 END) * 100, 2) AS percent_boleto
FROM 
    olist_order_payments;
-- 19.04% dos pedidos foram pagos através de boletos.


-- 24. Qual o tempo médio entre a entrega e a avaliação do pedido pelo cliente? 

SELECT 
    ROUND(AVG(TIMESTAMPDIFF(HOUR, o.order_delivered_customer_date, r.review_creation_date)), 2) AS tempo_medio_avaliacao_horas
FROM olist_orders o
JOIN olist_order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
AND r.review_creation_date IS NOT NULL
AND r.review_creation_date >= o.order_delivered_customer_date; /*A alguns erros nos Dados, algumas avaliações foram feitas antes da entrega do produto. Portanto, aqui filtro apenas
 avaliações criadas depois da entrega do produto. */
-- O tempo médio entre a entrega e a avaliação do pedido é de aproximadamente 9 horas.

 
-- 25. Qual foi o vendedor com o maior faturamento total?  

SELECT
	oi.seller_id AS vendedor,
    SUM(op.payment_value) AS faturamento_vendedor
FROM 
	olist_order_payments op
JOIN olist_order_items oi ON op.order_id = oi.order_id
GROUP BY vendedor
ORDER BY faturamento_vendedor DESC
LIMIT 1;
-- Não existe na base de Dados os nomes dos vendedores.
-- O vendedor de ID "7c67e1448b00f6e969d365cea6b010ab", foi oque teve maior faturamento (R$505.437,16).


-- 26. Qual a variação do volume de pedidos ao longo dos meses? 

WITH pedidos_mensais AS (
    SELECT 
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS mes_ano,
        COUNT(order_id) AS total_pedidos
    FROM olist_orders
    WHERE order_status = 'delivered'  -- Considera apenas pedidos entregues
    GROUP BY mes_ano
    ORDER BY mes_ano
)
SELECT 
    mes_ano,
    total_pedidos,
    LAG(total_pedidos) OVER (ORDER BY mes_ano) AS pedidos_mes_anterior,
    ROUND(
        (total_pedidos - LAG(total_pedidos) OVER (ORDER BY mes_ano)) / 
        LAG(total_pedidos) OVER (ORDER BY mes_ano) * 100, 
        2
    ) AS variacao_percentual
FROM pedidos_mensais;
/* RESULTADOS:
	mes_ano	| total_pedidos | pedidos_mes_anterior | variacao_percentual
	2016-09	|1		
	2016-10	|265	        |1	                    |26400.00
	2016-12	|1	            |265	                |-99.62
	2017-01	|748	        |1	                    |74700.00
	2017-02	|1641	        |748	                |119.39
	2017-03	|2546	        |1641	                |55.15
	2017-04	|2303	        |2546	                |-9.54
	2017-05	|3545	        |2303	                |53.93
	2017-06	|3135	        |3545	                |-11.57
	2017-07	|3872	        |3135	                |23.51
	2017-08	|4193	        |3872	                |8.29
	2017-09	|4149	        |4193	                |-1.05
	2017-10	|4478	        |4149	                |7.93
	2017-11	|7288	        |4478	                |62.75
	2017-12	|5513	        |7288	                |-24.36
	2018-01	|7069	        |5513	                |28.22
	2018-02	|6555	        |7069	                |-7.27
	2018-03	|7003	        |6555	                |6.83
	2018-04	|6798	        |7003	                |-2.93
	2018-05	|6749	        |6798	                |-0.72
	2018-06	|6096	        |6749	                |-9.68
	2018-07	|6156	        |6096	                |0.98
	2018-08	|6351	        |6156	                |3.17
*/



-- 27. Quantos clientes realizaram mais de cinco compras? 

SELECT COUNT(*) 
FROM (
    SELECT customer_id
    FROM olist_orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 5
) AS subquery;
-- Nenhum cliente realizou mais de 5 compras. 
