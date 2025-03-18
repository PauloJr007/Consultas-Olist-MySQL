USE olist;

-- 1. Quantos pedidos foram feitos?

SELECT 
	COUNT(DISTINCT(order_id)) -- Conta o número de pedidos
FROM 
	olist_orders;
-- Foram feitos 96461 pedidos.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Qual é o total de vendas (valor)?  

SELECT 
	SUM(payment_value) -- Soma a receita total
FROM 
	olist_order_payments;
-- A receita obtida foi de 15.4 Milhões de Reais. (Vendas e Frete)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. Quantos clientes estão registrados no Banco de Dados?

SELECT 
	COUNT(DISTINCT(customer_unique_id)) -- Conta o número de clientes distintos
FROM 
	olist_customers;
-- Existem 96096 clientes únicos registrados.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-- 4. Qual foi o mês com o maior volume de pedidos?  

SELECT 
    YEAR(order_purchase_timestamp) AS ano, -- Extrai o ano da data de compra
    MONTH(order_purchase_timestamp) AS mes, -- Extrai o mês da data de compra
    COUNT(order_id) AS total_pedidos -- Conta quantos pedidos foram feitos por mês
FROM 
	olist_orders
GROUP BY ano, mes -- Agrupa os pedidos por ano e mês
ORDER BY total_pedidos DESC -- Ordena do maior para o menor número de pedidos
LIMIT 1; -- Retorna apenas o mês (com o ano) com maior número de pedidos
-- O mês com maior volume de pedidos foi Novembro de 2017 (11/2017), com um total de 7288 pedidos.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5. Quais são as cinco categorias de produtos mais vendidas em quantidade de itens?  

SELECT 
    p.product_category_name AS categoria, -- Chamando a tabela 1
    COUNT(oi.order_item_id) AS total_itens_vendidos -- Conta o número de pedidos por categoria
FROM 
	olist_order_items oi -- Chamando a tabela 2
JOIN olist_products p ON oi.product_id = p.product_id -- Juntado as 2 tabelas pelo id comum
GROUP BY p.product_category_name -- Agrupa por categoria
ORDER BY total_itens_vendidos DESC -- Ordena do maior para o menor
LIMIT 5; -- Retorna as 5 categorias mais vendidas e a quantidade.
-- As cinco categorias mais vendidas são:
	/*
    1- cama_mesa_banho = 10952
    2- beleza_saude = 9467
    3- esporte_lazer = 8429
    4- moveis_decoracao = 8156
    5- informatica_acessorios = 7643
    */
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 6. Qual é o ticket médio por pedido? 

SELECT 
	AVG(payment_value) -- Calcula a média
FROM 
	olist_order_payments;
-- O ticket médio por pedido é de 153R$
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-- 7. Qual foi o tempo médio de entrega dos pedidos?

SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS tempo_medio_entrega -- Calcula a média da diferença entre a data de pedido e a data de entrega em dias
FROM 
	olist_orders
WHERE order_delivered_customer_date IS NOT NULL -- Filtra apenas os pedidos entregues
  AND order_purchase_timestamp IS NOT NULL; -- Filtra os valores não nulos
-- O tempo médio de entrega dos pedidos é de 12 dias.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 8. Quantos pedidos foram entregues com atraso?  

SELECT 
	COUNT(order_id) AS pedidos_com_atraso -- Conta os pedidos com atraso
FROM 
	olist_orders
WHERE order_estimated_delivery_date < order_delivered_customer_date -- Filtras os pedidos com atraso (Data estimada de entrega menor do que a data da entrega ao cliente)
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL;
-- 7826 pedidos foram entregue com atraso. 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 9. Qual o número médio de produtos por pedido?  

SELECT 
    AVG(itens_por_pedido) AS media_produtos_por_pedido -- Calcula a média de itens por pedido
FROM (
    -- Subconsulta que calcula a quantidade de itens por pedido
    SELECT 
        order_id,                        -- Seleciona o ID do pedido
        COUNT(order_item_id) AS itens_por_pedido -- Conta o número de itens em cada pedido
    FROM olist_order_items              -- Tabela de itens dos pedidos
    GROUP BY order_id                   -- Agrupa os resultados por ID do pedido
) AS subquery;                          -- Nome da subconsulta

-- 1 Produto (média = 1.14).
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 10. Qual é o estado com o maior número de pedidos? 

SELECT 
    oc.customer_state AS estados,          -- Seleciona o estado do cliente
    COUNT(o.order_id) AS total_pedidos     -- Conta o número total de pedidos por estado
FROM 
    olist_orders o                         -- Tabela de pedidos
JOIN olist_customers oc ON o.customer_id = oc.customer_id -- Junta a tabela de pedidos com a tabela de clientes usando o ID do cliente
GROUP BY oc.customer_state                -- Agrupa os resultados por estado do cliente
ORDER BY total_pedidos DESC;              -- Ordena os resultados pelo total de pedidos em ordem decrescente

-- O Estado com maior número de pedidos é São Paulo, com 40.489 pedidos.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-- 11. Qual é a média de avaliação dos pedidos?  

SELECT 
	AVG(review_score) -- Calcula a média da avaliação
FROM 
	olist_order_reviews;
-- A média de Avaliação dos Pedidos é de 4,08.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 12. Quantos pedidos tiveram avaliação menor ou igual a 3 estrelas?  

SELECT 
	COUNT(order_id) -- Conta o número de pedidos com nota menor ou igual a 3
FROM 
	olist_order_reviews
WHERE review_score <= 3; -- Filtra apenas os pedidos com nota menor ou igual a 3
-- 68 Pedidos tiveram avaliação menor ou igual a 3. 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 13. Qual foi a categoria de produto mais vendida em valor total de vendas?  

SELECT
    p.product_category_name AS categoria,  -- Seleciona o nome da categoria do produto
    SUM(oi.price) AS valor_total           -- Calcula a soma dos preços dos itens por categoria
FROM 
    olist_order_items oi                   -- Tabela de itens dos pedidos
JOIN olist_products p ON oi.product_id = p.product_id -- Junta a tabela de itens dos pedidos com a tabela de produtos usando o ID do produto
GROUP BY categoria                        -- Agrupa os resultados por categoria de produto
ORDER BY valor_total DESC                 -- Ordena os resultados pelo valor total em ordem decrescente
LIMIT 1;                                  -- Limita o resultado a uma linha (categoria com maior valor total)

-- A categoria mais vendida em valor é a "beleza_saude", tende gerado R$1.2 milhões
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 14. Qual foi o vendedor com o maior número de pedidos?

SELECT
    seller_id,                        -- Seleciona o ID do vendedor
    COUNT(order_id) AS pedidos        -- Conta o número de pedidos por vendedor
FROM 
    olist_order_items                 -- Tabela de itens dos pedidos
GROUP BY seller_id                   -- Agrupa os resultados por ID do vendedor
ORDER BY pedidos DESC;               -- Ordena os resultados pelo número de pedidos em ordem decrescente
-- O vendedor de id: '6560211a19b47992c3666cc44a7e94c0', foi o com maior número de pedidos, totalizando 1996 pedidos.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 15. Quais foram os cinco produtos mais vendidos em quantidade de unidades?  

SELECT
    product_id,                       -- Seleciona o ID do produto
    COUNT(order_id) AS quantidade_vendida -- Conta o número de pedidos por produto
FROM
    olist_order_items                 -- Tabela de itens dos pedidos
GROUP BY product_id                  -- Agrupa os resultados por ID do produto
ORDER BY quantidade_vendida DESC     -- Ordena os resultados pela quantidade de pedidos em ordem decrescente
LIMIT 5;                             -- Limita os resultados aos cinco produtos mais vendidos
-- **Não existe o real nome dos produtos na base de dados, por isso será usado o product_id que é o identificador dos produtos.**
-- Os cinco produtos mais vendidos em quantidade de unidades foram:
    /* 'aca2eb7d00ea1a7b8ebd4e68314663af': 520
       '422879e10f46682990de24d770e7f83d': 484
       '99a4788cb24856965c36a24e339b6058': 477
       '389d119b48cf3043d311335e499d9c6b': 390
       '368c6c730842d78016ad823897a372db': 388 */
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 16. Qual foi o mês com o maior faturamento total? 

SELECT 
    YEAR(shipping_limit_date) AS ano, -- Seleciona o ano da data limite de envio
    MONTH(shipping_limit_date) AS mes, -- Seleciona o mês da data limite de envio
    SUM(price) AS faturamento         -- Calcula a soma dos preços dos itens por mês
FROM 
    olist_order_items                 -- Tabela de itens dos pedidos
GROUP BY ano, mes                     -- Agrupa os resultados por ano e mês
ORDER BY faturamento DESC             -- Ordena os resultados pelo faturamento em ordem decrescente
LIMIT 1;                              -- Limita o resultado a uma linha (mês com maior faturamento)
-- O mês com maior faturamento foi em Maio de 2018 (05/2018), com um faturamento de R$1.06 milhões.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-- 17. Quantos pedidos foram cancelados? 

SELECT
    COUNT(order_id)                   -- Conta o número de pedidos
FROM
    olist_orders                      -- Tabela de pedidos
WHERE order_status = "canceled";      -- Filtra os pedidos que estão com o status "canceled"
-- Apenas 6 pedidos foram cancelados.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 18. Qual é o tempo médio entre a compra e a aprovação do pagamento?

SELECT 
    AVG(TIMESTAMPDIFF(hour, order_purchase_timestamp, order_approved_at)) AS tempo_medio_horas -- Calcula a média da diferença em horas entre a compra e a aprovação
FROM 
    olist_orders                 -- Tabela de pedidos
WHERE order_status = "delivered"; -- Filtra os pedidos que foram entregues
-- O tempo médio em horas entre a compra e a aprovação do pagamento é de aproximadamente 10 horas.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 19. Quantos pedidos tiveram frete grátis?

SELECT
    COUNT(order_id)               -- Conta o número de pedidos
FROM 
    olist_order_items             -- Tabela de itens dos pedidos
WHERE freight_value = 0;         -- Filtra os pedidos com valor de frete igual a zero
-- 381 pedidos tiveram frete grátis.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 20. Qual o valor médio do frete cobrado por pedido?

SELECT 
    AVG(freight_value)            -- Calcula a média do valor do frete
FROM 
    olist_order_items;            -- Tabela de itens dos pedidos
-- O valor médio do Frete é de R$19,94.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 21. Quantos pedidos foram feitos por clientes que já haviam comprado anteriormente?

SELECT 
    COUNT(o.order_id) AS total_pedidos_repetidos -- Conta o número total de pedidos repetidos
FROM 
    olist_orders o                -- Tabela de pedidos
JOIN olist_customers c ON o.customer_id = c.customer_id -- Junta a tabela de pedidos com a tabela de clientes usando o ID do cliente
WHERE c.customer_unique_id IN (   -- Filtra os pedidos feitos por clientes que já haviam comprado anteriormente
    SELECT 
        customer_unique_id
    FROM 
        olist_orders o2          -- Subconsulta na tabela de pedidos
    JOIN olist_customers c2 ON o2.customer_id = c2.customer_id -- Junta a tabela de pedidos com a tabela de clientes usando o ID do cliente na subconsulta
    GROUP BY c2.customer_unique_id -- Agrupa os resultados por ID único do cliente
    HAVING COUNT(o2.order_id) > 1  -- Filtra os clientes que fizeram mais de um pedido
);
-- Foram feitos 5919 pedidos por clientes que já haviam comprado anteriormente.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 22. Qual foi o maior valor de compra realizado por um único pedido?

SELECT 
    MAX(payment_value)            -- Seleciona o valor máximo do pagamento
FROM 
    olist_order_payments;         -- Tabela de pagamentos dos pedidos
-- O maior valor de compra em um único pedido foi de R$13.664,08.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 23. Qual é o percentual de pedidos pagos via boleto bancário?

SELECT 
    ROUND(AVG(CASE WHEN payment_type = 'boleto' THEN 1 ELSE 0 END) * 100, 2) AS percent_boleto -- Calcula a média dos pedidos pagos via boleto e converte em percentual
FROM 
    olist_order_payments;         -- Tabela de pagamentos dos pedidos
-- 19.04% dos pedidos foram pagos através de boletos.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 24. Qual o tempo médio entre a entrega e a avaliação do pedido pelo cliente?

SELECT 
    ROUND(AVG(TIMESTAMPDIFF(HOUR, o.order_delivered_customer_date, r.review_creation_date)), 2) AS tempo_medio_avaliacao_horas -- Calcula a média da diferença em horas entre a entrega e a avaliação
FROM olist_orders o               -- Tabela de pedidos
JOIN olist_order_reviews r ON o.order_id = r.order_id -- Junta a tabela de pedidos com a tabela de avaliações usando o ID do pedido
WHERE o.order_delivered_customer_date IS NOT NULL -- Filtra os pedidos que têm data de entrega
AND r.review_creation_date IS NOT NULL -- Filtra as avaliações que têm data de criação
AND r.review_creation_date >= o.order_delivered_customer_date; -- Filtra as avaliações criadas depois da entrega do produto
-- O tempo médio entre a entrega e a avaliação do pedido é de aproximadamente 9 horas.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-- 25. Qual foi o vendedor com o maior faturamento total?

SELECT
    oi.seller_id AS vendedor,     -- Seleciona o ID do vendedor
    SUM(op.payment_value) AS faturamento_vendedor -- Calcula a soma dos valores dos pagamentos por vendedor
FROM 
    olist_order_payments op       -- Tabela de pagamentos dos pedidos
JOIN olist_order_items oi ON op.order_id = oi.order_id -- Junta a tabela de pagamentos com a tabela de itens dos pedidos usando o ID do pedido
GROUP BY vendedor                -- Agrupa os resultados por ID do vendedor
ORDER BY faturamento_vendedor DESC -- Ordena os resultados pelo faturamento em ordem decrescente
LIMIT 1;                         -- Limita o resultado a uma linha (vendedor com maior faturamento)
-- Não existe na base de Dados os nomes dos vendedores.
-- O vendedor de ID "7c67e1448b00f6e969d365cea6b010ab", foi oque teve maior faturamento (R$505.437,16).

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 26. Qual a variação do volume de pedidos ao longo dos meses?

-- Cria uma CTE (Common Table Expression) para calcular o total de pedidos por mês
WITH pedidos_mensais AS (
    SELECT 
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS mes_ano, -- Formata a data da compra para 'ano-mês'
        COUNT(order_id) AS total_pedidos -- Conta o número total de pedidos por mês
    FROM olist_orders                     -- Tabela de pedidos
    WHERE order_status = 'delivered'      -- Considera apenas pedidos entregues
    GROUP BY mes_ano                      -- Agrupa os resultados por mês e ano
    ORDER BY mes_ano                      -- Ordena os resultados por mês e ano
)

-- Seleciona o mês-ano, total de pedidos, pedidos do mês anterior e variação percentual
SELECT 
    mes_ano,                              -- Seleciona o mês e ano
    total_pedidos,                        -- Seleciona o total de pedidos no mês
    LAG(total_pedidos) OVER (ORDER BY mes_ano) AS pedidos_mes_anterior, -- Calcula o total de pedidos do mês anterior
    ROUND(
        (total_pedidos - LAG(total_pedidos) OVER (ORDER BY mes_ano)) / 
        LAG(total_pedidos) OVER (ORDER BY mes_ano) * 100, 
        2
    ) AS variacao_percentual              -- Calcula a variação percentual do volume de pedidos em relação ao mês anterior
FROM pedidos_mensais;                     -- Utiliza a CTE criada anteriormente
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
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 27. Quantos clientes realizaram mais de cinco compras? 

SELECT COUNT(*) 
FROM (
    -- Subconsulta que seleciona o ID dos clientes que fizeram mais de 5 pedidos
    SELECT customer_id               -- Seleciona o ID do cliente
    FROM olist_orders                -- Tabela de pedidos
    GROUP BY customer_id             -- Agrupa os resultados por ID do cliente
    HAVING COUNT(order_id) > 5       -- Filtra os clientes que fizeram mais de 5 pedidos
) AS subquery;                       -- Nome da subconsulta

-- Nenhum cliente realizou mais de 5 compras. 
