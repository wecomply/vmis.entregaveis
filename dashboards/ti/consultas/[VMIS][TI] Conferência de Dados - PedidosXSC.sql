/***** KPI: Lista de Pedidos de Compra do Sistema com e sem Solicitação de Compras ****/

/* Lista de tabelas consumidas nesta consulta: */
	-- PROTHEUS12.dbo.SC7010 - Informações dos Pedidos de Compra do Sistema

/* KPI's atendidos por esta consulta: */
	-- 1) Quantidade de pedidos por período que possuem ou não Solicitação de Compra;
	-- 2) Quantidade de pedidos por fornecedor que possuem ou não Solicitação de Compra;
	-- 3) Quantidade de pedidos por solicitante que possuem ou não Solicitação de Compra;
	-- 4) Quantidade de pedidos por condição de pagamento que possuem ou não Solicitação de Compra;
	-- 5) Quantidade de pedidos por moeda que possuem ou não Solicitação de Compra;

SELECT 
	PED.C7_FILIAL, 
	PED.C7_NUM, 
	PED.C7_ITEM, 
	PED.C7_EMISSAO, 
	PED.C7_FORNECE, 
	PED.C7_COND, 
	PED.C7_MOEDA, 
	CASE PED.C7_MOEDA
		WHEN '1' THEN 'Real'
		WHEN '2' THEN 'Dolar'
		WHEN '4' THEN 'Euro'
		WHEN '6' THEN 'Peso Mexicano'
		WHEN '7' THEN 'Peso Argentino'
		ELSE 'Desconhecido'
	END AS C7_MOEDA_DESC,
	PED.C7_NUMSC, 
	PED.C7_ITEMSC, 
	PED.C7_USER, 
	UPPER(USER_PROTHEUS.USR_NOME) AS USR_NOME, 
	LOWER(USER_PROTHEUS.USR_EMAIL) AS USR_EMAIL, 
	UPPER(USER_PROTHEUS.USR_DEPTO) AS USR_DEPTO, 
	UPPER(USER_PROTHEUS.USR_CARGO) AS USR_CARGO
FROM SC7010 PED

LEFT JOIN SYS_USR USER_PROTHEUS ON USER_PROTHEUS.USR_ID = PED.C7_USER AND USER_PROTHEUS.D_E_L_E_T_ = ''

WHERE PED.D_E_L_E_T_ = '' AND PED.C7_EMISSAO >= 20250101 --AND C7_NUMSC = ''
GROUP BY 
	PED.C7_FILIAL, 
	PED.C7_NUM, 
	PED.C7_ITEM, 
	PED.C7_EMISSAO, 
	PED.C7_FORNECE, 
	PED.C7_COND, 
	PED.C7_MOEDA, 
	PED.C7_NUMSC, 
	PED.C7_ITEMSC, 
	PED.C7_USER, 
	USER_PROTHEUS.USR_NOME, 
	USER_PROTHEUS.USR_EMAIL, 
	USER_PROTHEUS.USR_DEPTO, 
	USER_PROTHEUS.USR_CARGO
ORDER BY C7_NUM DESC, C7_ITEM ASC