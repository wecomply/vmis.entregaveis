/***** KPI: Comparativo entre Tabela de Medi��es do Sistema e Workflow de Aprova��es  ****/

/* Lista de tabelas consumidas nesta consulta: */
	-- PROTHEUS12.dbo.CND010 - Informa��es das Medi��es do Sistema
	-- PROTHEUS12.dbo.SCR010 - Informa��es do Fluxo de Aprova��o

/* Lista de pend�ncias identificadas e dificuldades encontradas: */
	-- 1) Ainda n�o � poss�vel identificar quem foi o criador da medi��o;
	-- 2) Algumas informa��es como CND_SITUAC e CND_FILCTR n�o est�o claras;
	-- 3) Os dados dos fornecedores n�o est�o preenchidos CND_FORNEC;

/* KPI's atendidos por esta consulta: */
	-- 1) Quantidade de medi��es por per�odo que passaram ou n�o pelo Workflow;
	-- 2) Quantidade de medi��es por contrato que passaram ou n�o pelo Workflow;
	-- 3) Quantidade de medi��es por compet�ncia que passaram ou n�o pelo Workflow;
	-- 4) Quantidade de medi��es por condi��o de pagamento que passaram ou n�o pelo Workflow;
	-- 5) Quantidade de medi��es por situa��o/filctr que passaram ou n�o pelo Workflow;

SELECT CND.CND_NUMMED, CND.CND_REVISA, CND.CND_DTINIC, CND.CND_CONTRA, CNE.CNE_CC, CNE.CNE_CONTA, LEFT(WORKFLOW_APROVACAO.CR_NUM, 6) AS CR_NUM, WORKFLOW_APROVACAO.CR_EMISSAO
FROM CND010 CND

LEFT JOIN (SELECT LEFT(CR_NUM, 6) AS CR_NUM, CR_EMISSAO FROM SCR010 WHERE D_E_L_E_T_ = '' AND CR_TIPO IN ('IM') GROUP BY LEFT(CR_NUM, 6), CR_EMISSAO) AS WORKFLOW_APROVACAO ON LEFT(WORKFLOW_APROVACAO.CR_NUM, 6) = CND.CND_NUMMED
LEFT JOIN CNE010 CNE ON CNE.CNE_NUMMED = CND.CND_NUMMED AND CNE.D_E_L_E_T_ = ''

WHERE CND.D_E_L_E_T_ = '' AND CND.CND_DTINIC >= 20250101
GROUP BY CND.CND_NUMMED, CND.CND_REVISA, CND.CND_DTINIC, CND.CND_CONTRA, CNE.CNE_CC, CNE.CNE_CONTA, CR_NUM, CR_EMISSAO
ORDER BY CND.CND_NUMMED DESC, CND.CND_REVISA DESC, CND.CND_DTINIC DESC;