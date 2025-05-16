/***** KPI: Comparativo entre Tabela de Pedido de Compras do Sistema e Workflow de Aprovações  ****/

/* Lista de tabelas consumidas nesta consulta: */
	-- PROTHEUS12.dbo.SC7010 - Informações dos Pedidos de Compra do Sistema
	-- PROTHEUS12.dbo.SCR010 - Informações do Fluxo de Aprovação

/* KPI's atendidos por esta consulta: */
	-- 1) Quantidade de pedidos por período que passaram ou não pelo Workflow;
	-- 2) Quantidade de pedidos por fornecedor que passaram ou não pelo Workflow;
	-- 3) Quantidade de pedidos por conta contabil ou centro de custos que passaram ou não pelo Workflow;
	-- 4) Quantidade de pedidos por condição de pagamento que passaram ou não pelo Workflow;

/** Pedidos comparados ao workflow de aprovação **/

SELECT PED.C7_FILIAL, PED.C7_NUM, PED.C7_ITEM, PED.C7_EMISSAO, PED.C7_FORNECE, PED.C7_COND, PED.C7_CONTA, PED.C7_CC, PED.C7_NUMSC, PED.C7_ITEMSC, LEFT(WORKFLOW_APROVACAO.CR_NUM, 6) AS CR_NUM, WORKFLOW_APROVACAO.CR_EMISSAO
FROM SC7010 PED

LEFT JOIN (SELECT LEFT(CR_NUM, 6) AS CR_NUM, CR_EMISSAO FROM SCR010 WHERE D_E_L_E_T_ = '' AND CR_TIPO IN ('PC') GROUP BY LEFT(CR_NUM, 6), CR_EMISSAO) AS WORKFLOW_APROVACAO ON LEFT(WORKFLOW_APROVACAO.CR_NUM, 6) = PED.C7_NUM
LEFT JOIN CNE010 CNE ON CNE.CNE_NUMMED = PED.C7_NUM AND CNE.D_E_L_E_T_ = ''

WHERE PED.D_E_L_E_T_ = '' AND PED.C7_EMISSAO >= 20250401 AND WORKFLOW_APROVACAO.CR_NUM is NULL
GROUP BY PED.C7_FILIAL, PED.C7_NUM, PED.C7_ITEM, PED.C7_EMISSAO, PED.C7_FORNECE, PED.C7_COND, PED.C7_CONTA, PED.C7_CC, PED.C7_NUMSC, PED.C7_ITEMSC, CR_NUM, CR_EMISSAO
ORDER BY C7_NUM DESC, C7_ITEM ASC