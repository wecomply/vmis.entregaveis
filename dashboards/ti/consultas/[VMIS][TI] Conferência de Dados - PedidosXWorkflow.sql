/***** KPI: Comparativo entre Tabela de Pedido de Compras do Sistema e Workflow de Aprova��es  ****/

/* Lista de tabelas consumidas nesta consulta: */
	-- PROTHEUS12.dbo.SC7010 - Informa��es dos Pedidos de Compra do Sistema
	-- PROTHEUS12.dbo.SCR010 - Informa��es do Fluxo de Aprova��o

/* KPI's atendidos por esta consulta: */
	-- 1) Quantidade de pedidos por per�odo que passaram ou n�o pelo Workflow;
	-- 2) Quantidade de pedidos por fornecedor que passaram ou n�o pelo Workflow;
	-- 3) Quantidade de pedidos por conta contabil ou centro de custos que passaram ou n�o pelo Workflow;
	-- 4) Quantidade de pedidos por condi��o de pagamento que passaram ou n�o pelo Workflow;

/** Pedidos comparados ao workflow de aprova��o **/

SELECT PED.C7_FILIAL, PED.C7_NUM, PED.C7_ITEM, PED.C7_EMISSAO, PED.C7_FORNECE, PED.C7_COND, PED.C7_CONTA, PED.C7_CC, PED.C7_NUMSC, PED.C7_ITEMSC, LEFT(WORKFLOW_APROVACAO.CR_NUM, 6) AS CR_NUM, WORKFLOW_APROVACAO.CR_EMISSAO
FROM SC7010 PED

LEFT JOIN (SELECT LEFT(CR_NUM, 6) AS CR_NUM, CR_EMISSAO FROM SCR010 WHERE D_E_L_E_T_ = '' AND CR_TIPO IN ('PC') GROUP BY LEFT(CR_NUM, 6), CR_EMISSAO) AS WORKFLOW_APROVACAO ON LEFT(WORKFLOW_APROVACAO.CR_NUM, 6) = PED.C7_NUM
LEFT JOIN CNE010 CNE ON CNE.CNE_NUMMED = PED.C7_NUM AND CNE.D_E_L_E_T_ = ''

WHERE PED.D_E_L_E_T_ = '' AND PED.C7_EMISSAO >= 20250401 AND WORKFLOW_APROVACAO.CR_NUM is NULL
GROUP BY PED.C7_FILIAL, PED.C7_NUM, PED.C7_ITEM, PED.C7_EMISSAO, PED.C7_FORNECE, PED.C7_COND, PED.C7_CONTA, PED.C7_CC, PED.C7_NUMSC, PED.C7_ITEMSC, CR_NUM, CR_EMISSAO
ORDER BY C7_NUM DESC, C7_ITEM ASC