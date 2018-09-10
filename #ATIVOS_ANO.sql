-- Pivot para Atributos
WITH
codPivot AS (

SELECT AFCODEMP AS EMPRESA, AFMATFUNC AS MATRICULA,
		MAX(CASE WHEN AFCODATRIB = 5 THEN AFVALOR END) AS LOCALIDADE,
		MAX(CASE WHEN AFCODATRIB = 47 THEN AFVALOR END) AS POSICAO,
		MAX(CASE WHEN AFCODATRIB = 41 THEN AFVALOR END) AS AREA,
		MAX(CASE WHEN AFCODATRIB = 43 THEN AFVALOR END) AS REPORT_FRANCA,
		MAX(CASE WHEN AFCODATRIB = 40 THEN AFVALOR END) AS TIPO_CONTRATO
  FROM ATRIBFUN
  WHERE AFCODATRIB IN (5, 47, 41, 43, 40)
  GROUP BY AFCODEMP, AFMATFUNC
			),
-- Pivot para Eventos
pivotEVEFUNC AS (

SELECT VACODEMP AS EMPRESA, VAMATFUNC AS MATRICULA, VADTREFER AS REFERENCIA,
       MAX(CASE WHEN VACODEVENT = 245 	THEN VAVALEVENT END) AS NOTA_FISCAL,
       MAX(CASE WHEN VACODEVENT = 2630 	THEN VAVALEVENT END) AS PRO_LABORE,
       MAX(CASE WHEN VACODEVENT = 4110 	THEN VAVALEVENT END) AS ANTECIPACAO_LUCROS,
	   MAX(CASE WHEN VACODEVENT = 11000	THEN VAVALEVENT END) AS SALARIO_CONTRATUAL,
       MAX(CASE WHEN VACODEVENT = 5 	THEN VAVALEVENT END) AS SALARIO_MENSAL,
	   MAX(CASE WHEN VACODEVENT = 10100 THEN VAVALEVENT END) AS BASE_INSS_MES,
	   MAX(CASE WHEN VACODEVENT = 10140 THEN VAVALEVENT END) AS BASE_FGTS_MES,
	   MAX(CASE WHEN VACODEVENT = 25020 THEN VAVALEVENT END) AS PROV_FERIAS_MES,
	   MAX(CASE WHEN VACODEVENT = 25670 THEN VAVALEVENT END) AS TERCO_FERIAS_MES,
	   MAX(CASE WHEN VACODEVENT = 25150 THEN VAVALEVENT END) AS INSS_PROV_FERIAS_MES,
	   MAX(CASE WHEN VACODEVENT = 26710 THEN VAVALEVENT END) AS PROV_13_MES,
	   MAX(CASE WHEN VACODEVENT = 26820 THEN VAVALEVENT END) AS INSS_PROV_13_MES,
	   MAX(CASE WHEN VACODEVENT = 25540 THEN VAVALEVENT END) AS FGTS_PROV_MES,
	   MAX(CASE WHEN VACODEVENT = 00045 THEN VAVALEVENT END) AS HE_50,
	   MAX(CASE WHEN VACODEVENT = 00050 THEN VAVALEVENT END) AS HE_60,
	   MAX(CASE WHEN VACODEVENT = 00070 THEN VAVALEVENT END) AS HE_80,
	   MAX(CASE WHEN VACODEVENT = 00090 THEN VAVALEVENT END) AS HE_100,
	   MAX(CASE WHEN VACODEVENT = 00120 THEN VAVALEVENT END) AS DSR_HE,
	   MAX(CASE WHEN VACODEVENT = 00030 THEN VAVALEVENT END) AS ADC_NOT_RJ,
	   MAX(CASE WHEN VACODEVENT = 00035 THEN VAVALEVENT END) AS ADC_NOT_SP,
	   MAX(CASE WHEN VACODEVENT = 00115 THEN VAVALEVENT END) AS DSR_ADC_NOT,
	   MAX(CASE WHEN VACODEVENT = 30090 THEN VAVALEVENT END) AS VR_COMPENSADO,
	   MAX(CASE WHEN VACODEVENT = 00125 THEN VAVALEVENT END) AS COMISSAO,
	   MAX(CASE WHEN VACODEVENT = 00025 THEN VAVALEVENT END) AS DSR_COMISSAO,
	   MAX(CASE WHEN VACODEVENT = 00410 THEN VAVALEVENT END) AS PREMIOS,
	   MAX(CASE WHEN VACODEVENT = 11876 THEN VAVALEVENT END) AS VT_EMPRESA
	   
  FROM VALANO
  WHERE VACODEVENT IN (245, 2630, 4110, 11000, 5, 10100, 10140, 25020, 25670, 25150, 26710, 26820, 25540, 00045, 00050, 00070, 00090, 00120, 00030, 00035, 00115, 30090, 00125, 00025, 00410,11876)
  AND VACODFOLHA IN (1, 16, 32)
  AND VADTREFER = 201807 
  GROUP BY VACODEMP, VAMATFUNC, VADTREFER
			)
			SELECT
	EMCODEMP	AS COD_EMPRESA,
	EMNOMEMP	AS EMPRESA,
	FUMATFUNC AS MATRICULA,
	FUNOMFUNC AS NOME,
	FUEMAIL		AS EMAIL,
	AF.TIPO_CONTRATO,
	STDESCSITU	AS STATUS,
	CASE STTIPOSITU
		WHEN 'N' THEN 'ATIVO'
		WHEN 'A' THEN 'AFASTADO'
		WHEN 'R' THEN 'DESLIGADO'
		WHEN 'F' THEN 'FERIAS' END AS SITUACAO,
	AF.LOCALIDADE,
	CASE FUSEXFUNC
		WHEN 'F' THEN 'FEMININO'
		WHEN 'M' THEN 'MASCULINO' END AS SEXO,
	CASE FUCODTIPOLOGRADOURO 
		WHEN 0 THEN ' ' 
		WHEN 2 THEN 'ALAMEDA' 
		WHEN 4 THEN 'AVENIDA' 
		WHEN 13 THEN 'ESTRADA' 
		WHEN 33 THEN 'RUA' 
		WHEN 36 THEN 'TRAVESSA' ELSE 'OUTROS' END + ' ' + FUENDERECO + ', ' +
		SUBSTRING(CONVERT(VARCHAR(5),FUNUMERO),1,LEN(FUNUMERO)) + ' - ' +
		SUBSTRING(CONVERT(VARCHAR(15),FUCOMPLEMENTO),1,LEN(FUCOMPLEMENTO)) AS ENDERECO,
	FUBAIRRO	AS BAIRRO,
	FUCPF		AS CPF,
	FUIDENTNUM	AS RG,
		SUBSTRING(CONVERT(VARCHAR(8),FUCTRABNUM),1,LEN(FUCTRABNUM)) + '/' + 
		SUBSTRING(CONVERT(VARCHAR(5),FUCTRABSER),1,LEN(FUCTRABNUM)) + '-' +
		SUBSTRING(CONVERT(CHAR(2),FUCTRABUF),1,2) AS CTPS,
		FUPISPASEP AS PIS,
	CASE FUESTCIVIL
		WHEN '1' THEN 'SOLTEIRO'
		WHEN '2' THEN 'CASADO'
		WHEN '3' THEN 'SEPARADO JUDICIALMENTE'
		WHEN '4' THEN 'DIVORCIADO'
		WHEN '5' THEN 'VIUVO'
		WHEN '6' THEN 'OUTROS'
		WHEN '7' THEN 'IGNORADO'  END AS ESTADO_CIVIL,
		CONVERT(VARCHAR(11),CONVERT(DATE,CONVERT(VARCHAR(11),FUDTNASC),112), 103) AS DATA_NASCIMENTO,
	FUIDADE		AS IDADE,
		CONVERT(VARCHAR(11),CONVERT(DATE,CONVERT(VARCHAR(11),FUDTADMIS),112), 103) AS DATA_ADMISSAO,

		-- Tempo de Casa
	CONVERT(CHAR(2), DATEDIFF(DAY, CONVERT(DATE,CONVERT(VARCHAR(11),FUDTADMIS),112), GETDATE()) / 365) + ' Anos e ' +
	CONVERT(CHAR(2), DATEDIFF(MONTH, CONVERT(DATE,CONVERT(VARCHAR(11),FUDTADMIS),112), GETDATE()) % 12) + ' Meses' AS TEMPO_DE_CASA,
		-- Tempo de Casa

	FUCENTRCUS AS CEN_CUSTO,
	CCDESCRIC AS DESC_CCUSTO,
	CADESCARGO AS DESC_CARGO,
	AF.POSICAO,
	AF.REPORT_FRANCA,
	AF.AREA,
	VA.REFERENCIA,
	
	-- REMUNERACAO
	VA.SALARIO_CONTRATUAL,
	VA.SALARIO_MENSAL,
	VA.PRO_LABORE,
	VA.ANTECIPACAO_LUCROS,
	VA.NOTA_FISCAL,
	-- REMUNERACAO
	
	ISNULL(VA.SALARIO_MENSAL,0) + ISNULL(VA.PRO_LABORE,0) + ISNULL(VA.ANTECIPACAO_LUCROS,0) + ISNULL(VA.NOTA_FISCAL,0) AS REMUNERACAO,
	
	-- BASES
	VA.BASE_INSS_MES,
	VA.BASE_FGTS_MES,
	-- BASES
	
	-- ENCARGOS
	ISNULL(VA.PROV_FERIAS_MES,0) + ISNULL(VA.TERCO_FERIAS_MES,0) AS PROV_FERIAS_TERCO_MES,	
	VA.INSS_PROV_FERIAS_MES,
	VA.PROV_13_MES,
	VA.INSS_PROV_13_MES,
	-- ENCARGOS
	
	-- VARIAVEIS
	VA.HE_50,
	VA.HE_60,
	VA.HE_80,
	VA.HE_100,
	VA.DSR_HE,
	VA.ADC_NOT_RJ,
	VA.ADC_NOT_SP,
	VA.DSR_ADC_NOT,
	VA.COMISSAO,
	VA.DSR_COMISSAO,
	VA.PREMIOS,
	-- VARIAVEIS
	
	-- BENEFICIOS	
	VA.VR_COMPENSADO,
	VA.VT_EMPRESA
	-- BENEFICIOS
	
	
FROM FUNCIONA
       INNER JOIN EMPRESAS ON EMCODEMP = FUCODEMP
	   INNER JOIN CARGOS ON CACODEMP = FUCODEMP AND CACODCARGO = FUCODCARGO
       INNER JOIN CENCUSTO ON CCCODEMP = FUCODEMP AND CCCODIGO = FUCENTRCUS
	   INNER JOIN SITUACAO ON STCODSITU = FUCODSITU
       LEFT JOIN codPivot AS AF ON AF.EMPRESA = FUCODEMP AND AF.MATRICULA = FUMATFUNC
       LEFT JOIN pivotEVEFUNC AS VA ON VA.EMPRESA = FUCODEMP AND VA.MATRICULA = FUMATFUNC
	WHERE FUCODEMP < 500
	AND STTIPOSITU <> 'R'
	ORDER BY AF.EMPRESA, FUNOMFUNC;