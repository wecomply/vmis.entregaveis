/***** KPI: Comparativo entre Tabela de Medições do Sistema e Workflow de Aprovações  ****/

/* Lista de tabelas consumidas nesta consulta: */
	-- PROTHEUS12.dbo.CND010 - Informações das Medições do Sistema
	-- PROTHEUS12.dbo.SCR010 - Informações do Fluxo de Aprovação

/* Lista de pendências identificadas e dificuldades encontradas: */
	-- 1) Ainda não é possível identificar quem foi o criador da medição;
	-- 2) Algumas informações como CND_SITUAC e CND_FILCTR não estão claras;
	-- 3) Os dados dos fornecedores não estão preenchidos CND_FORNEC;

/* KPI's atendidos por esta consulta: */
	-- 1) Quantidade de medições por período que passaram ou não pelo Workflow;
	-- 2) Quantidade de medições por contrato que passaram ou não pelo Workflow;
	-- 3) Quantidade de medições por competência que passaram ou não pelo Workflow;
	-- 4) Quantidade de medições por condição de pagamento que passaram ou não pelo Workflow;
	-- 5) Quantidade de medições por situação/filctr que passaram ou não pelo Workflow;

SELECT CND.CND_NUMMED, CND.CND_REVISA, CND.CND_DTINIC, CND.CND_CONTRA, CNE.CNE_CC, CNE.CNE_CONTA, LEFT(WORKFLOW_APROVACAO.CR_NUM, 6) AS CR_NUM, WORKFLOW_APROVACAO.CR_EMISSAO
FROM CND010 CND

LEFT JOIN (SELECT LEFT(CR_NUM, 6) AS CR_NUM, CR_EMISSAO FROM SCR010 WHERE D_E_L_E_T_ = '' AND CR_TIPO IN ('IM') GROUP BY LEFT(CR_NUM, 6), CR_EMISSAO) AS WORKFLOW_APROVACAO ON LEFT(WORKFLOW_APROVACAO.CR_NUM, 6) = CND.CND_NUMMED
LEFT JOIN CNE010 CNE ON CNE.CNE_NUMMED = CND.CND_NUMMED AND CNE.D_E_L_E_T_ = ''

WHERE CND.D_E_L_E_T_ = '' AND CND.CND_DTINIC >= 20250101
GROUP BY CND.CND_NUMMED, CND.CND_REVISA, CND.CND_DTINIC, CND.CND_CONTRA, CNE.CNE_CC, CNE.CNE_CONTA, CR_NUM, CR_EMISSAO
ORDER BY CND.CND_NUMMED DESC, CND.CND_REVISA DESC, CND.CND_DTINIC DESC;