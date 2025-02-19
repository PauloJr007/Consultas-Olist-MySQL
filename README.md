# Análise do Dataset Olist com MySQL

Neste projeto, realizei consultas SQL utilizando o MySQL Workbench em um dataset público da startup brasileira Olist, que atua no setor de tecnologia para varejo. O objetivo foi explorar e analisar dados relacionados a pedidos, vendas, clientes e logística.

Foram utilizadas diversas instruções SQL, incluindo **SELECT, subqueries, JOINs, entre outras**.

Para este projeto, defini **27 perguntas-chave** a serem respondidas por meio das consultas SQL:

1) Quantos pedidos foram feitos?  
2) Qual é o total de vendas (valor)?  
3) Quantos clientes únicos realizaram pelo menos uma compra?  
4) Qual foi o mês com o maior volume de pedidos?  
5) Quais são as cinco categorias de produtos mais vendidas em quantidade de itens?  
6) Qual é o ticket médio por pedido?  
7) Qual foi o tempo médio de entrega dos pedidos?  
8) Quantos pedidos foram entregues com atraso?  
9) Qual o número médio de produtos por pedido?  
10) Qual é o estado com o maior número de pedidos?  
11) Qual é a média de avaliação dos pedidos?  
12) Quantos pedidos tiveram avaliação menor ou igual a 3 estrelas?  
13) Qual foi a categoria de produto mais vendida em valor total de vendas?  
14) Qual foi o vendedor com o maior número de pedidos?  
15) Quais foram os cinco produtos mais vendidos em quantidade de unidades?  
16) Qual foi o mês com o maior faturamento total?  
17) Quantos pedidos foram cancelados?  
18) Qual é o tempo médio entre a compra e a aprovação do pagamento?  
19) Quantos pedidos tiveram frete grátis?  
20) Qual o valor médio do frete cobrado por pedido?  
21) Quantos pedidos foram feitos por clientes que já haviam comprado anteriormente?  
22) Qual foi o maior valor de compra realizado por um único pedido?  
23) Qual é o percentual de pedidos pagos via boleto bancário?  
24) Qual o tempo médio entre a entrega e a avaliação do pedido pelo cliente?  
25) Qual foi o vendedor com o maior faturamento total?  
26) Qual a variação do volume de pedidos ao longo dos meses?  
27) Quantos clientes realizaram mais de cinco compras?  

## Estrutura do Projeto

Durante a análise, duas tabelas foram consideradas não essenciais e, portanto, não utilizadas:
- **`olist_geolocation`**: Contém dados de latitude e longitude, irrelevantes para as análises realizadas.  
- **`product_category_name_translation`**: Contém tradução dos nomes das categorias, já disponível na tabela `olist_products`.  

### Pastas do Repositório:
- **`Dados`**: Contém os arquivos com as tabelas utilizadas no projeto.
- **`Código-SQL`**: Contém os scripts SQL utilizados para criar o banco de dados, definir chaves primárias (PK) e estrangeiras (FK), e executar as consultas.

### Fonte do Dataset:
O dataset original pode ser encontrado no **Kaggle**: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

---

Este projeto explora insights valiosos sobre o comportamento dos clientes, desempenho de vendas e logística da Olist. As consultas podem ser reutilizadas ou adaptadas para diferentes contextos de análise de dados no e-commerce.

