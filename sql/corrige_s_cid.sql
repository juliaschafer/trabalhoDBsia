-- Correcao da tabela s_cid (banco dbsia)
-- O S_CID.csv traz 14 codigos repetidos em minusculo (ex.: 'j450' = "CID NAO IDENTIFICADO")
-- ao lado do codigo correto ('J450'). Como a collation do MySQL nao diferencia maiusculas,
-- o JOIN da VIEW pa_ijui casa as duas linhas e duplica 1.550 registros de Ijui
-- (70.377 na VIEW contra 68.827 reais na tabela pars).
-- Rodar no mysql com:  source /Users/juliakellerschafer/Documents/datasus/corrige_s_cid.sql

use dbsia;

-- Conferencia antes: deve mostrar 14 linhas
SELECT CD_COD, CD_DESCR FROM s_cid WHERE BINARY CD_COD <> BINARY UPPER(CD_COD);

DELETE FROM s_cid WHERE BINARY CD_COD <> BINARY UPPER(CD_COD);

-- Indice para filtrar Ijui direto na pars (usado no notebook)
CREATE INDEX idx_pars_ufmun ON pars (PA_UFMUN);

-- Conferencia depois: os dois numeros devem ser iguais (68827)
SELECT (SELECT COUNT(*) FROM pa_ijui) AS linhas_view,
       (SELECT COUNT(*) FROM pars WHERE PA_UFMUN = '431020') AS linhas_pars;
