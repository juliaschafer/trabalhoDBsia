-- Tabelas auxiliares do SIA-SUS + indices da tabela pars (banco dbsia)
-- Rodar no mysql com:  mysql --local-infile=1 -u root -p dbsia
-- (dentro do mysql>)   source /Users/juliakellerschafer/Documents/datasus/create_auxiliares.sql

create database if not exists dbsia;
use dbsia;

DROP TABLE IF EXISTS cadgerrs;
create TABLE cadgerrs(
    CNES VARCHAR(7),
    CPF_CNPJ VARCHAR(14),
    FANTASIA VARCHAR(60),
    RAZ_SOCI VARCHAR(85),
    RSOC_MAN VARCHAR(60),
    LOGRADOU VARCHAR(40),
    NUM_END VARCHAR(10),
    COMPLEME VARCHAR(20),
    BAIRRO VARCHAR(20),
    COD_CEP VARCHAR(8),
    TELEFONE VARCHAR(13),
    FAX VARCHAR(13),
    EMAIL VARCHAR(30),
    REGSAUDE VARCHAR(4),
    MICR_REG VARCHAR(6),
    DISTRSAN VARCHAR(4),
    DISTRADM VARCHAR(4),
    CODUFMUN VARCHAR(6),
    EXCLUIDO VARCHAR(1),
    DATAINCL DATE,
    DATAEXCL DATE,
    NATUREZA VARCHAR(2)
);

LOAD DATA LOCAL INFILE '/Users/juliakellerschafer/Documents/datasus/csv/CADGERRS.csv'
INTO TABLE cadgerrs
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  CNES,
  CPF_CNPJ,
  FANTASIA,
  RAZ_SOCI,
  RSOC_MAN,
  LOGRADOU,
  NUM_END,
  COMPLEME,
  BAIRRO,
  COD_CEP,
  TELEFONE,
  FAX,
  EMAIL,
  REGSAUDE,
  MICR_REG,
  DISTRSAN,
  DISTRADM,
  CODUFMUN,
  EXCLUIDO,
  @DATAINCL,
  @DATAEXCL,
  NATUREZA
)
SET
  DATAINCL = NULLIF(TRIM(@DATAINCL), ''),
  DATAEXCL = NULLIF(TRIM(@DATAEXCL), '');

DROP TABLE IF EXISTS tb_sigtaw;
create TABLE tb_sigtaw(
    IP_COD VARCHAR(10),
    IP_DSCR VARCHAR(150)
);

LOAD DATA LOCAL INFILE '/Users/juliakellerschafer/Documents/datasus/csv/TB_SIGTAW.csv'
INTO TABLE tb_sigtaw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  IP_COD,
  IP_DSCR
);

DROP TABLE IF EXISTS cbo;
create TABLE cbo(
    CBO VARCHAR(6),
    DS_CBO VARCHAR(150)
);

LOAD DATA LOCAL INFILE '/Users/juliakellerschafer/Documents/datasus/csv/CBO.csv'
INTO TABLE cbo
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  CBO,
  DS_CBO
);

DROP TABLE IF EXISTS s_cid;
create TABLE s_cid(
    CD_COD VARCHAR(4),
    OPC VARCHAR(1),
    CAT VARCHAR(1),
    SUBCAT VARCHAR(1),
    CD_DESCR VARCHAR(50),
    RESTRSEXO VARCHAR(1),
    CAMPOS_RAD VARCHAR(3),
    ESTADIO VARCHAR(1),
    REPETE_RAD VARCHAR(1)
);

LOAD DATA LOCAL INFILE '/Users/juliakellerschafer/Documents/datasus/csv/S_CID.csv'
INTO TABLE s_cid
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  CD_COD,
  OPC,
  CAT,
  SUBCAT,
  CD_DESCR,
  RESTRSEXO,
  CAMPOS_RAD,
  ESTADIO,
  REPETE_RAD
);

-- O CSV tem 14 codigos repetidos em minusculo ("CID NAO IDENTIFICADO"); como a collation
-- nao diferencia maiusculas, eles duplicariam linhas nos JOINs com pars.
DELETE FROM s_cid WHERE BINARY CD_COD <> BINARY UPPER(CD_COD);

DROP TABLE IF EXISTS tb_municip;
create TABLE tb_municip(
    cod_municip VARCHAR(6),
    nome_municip VARCHAR(60)
);

LOAD DATA LOCAL INFILE '/Users/juliakellerschafer/Documents/datasus/csv/tb_municip.csv'
INTO TABLE tb_municip
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  cod_municip,
  nome_municip
);

DROP TABLE IF EXISTS tb_micibge;
create TABLE tb_micibge(
    cod_micibge VARCHAR(5),
    nome_micibge VARCHAR(60)
);

LOAD DATA LOCAL INFILE '/Users/juliakellerschafer/Documents/datasus/csv/tb_micibge.csv'
INTO TABLE tb_micibge
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  cod_micibge,
  nome_micibge
);

DROP TABLE IF EXISTS rl_municip_micibge;
create TABLE rl_municip_micibge(
    cod_micibge VARCHAR(5),
    cod_municip VARCHAR(6)
);

LOAD DATA LOCAL INFILE '/Users/juliakellerschafer/Documents/datasus/csv/rl_municip_micibge.csv'
INTO TABLE rl_municip_micibge
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  cod_micibge,
  cod_municip
);

-- Visao com o nome 'procedimentos' (mesma tabela TB_SIGTAW: codigo SIGTAP + descricao)
CREATE OR REPLACE VIEW procedimentos AS SELECT IP_COD AS cod_procedimento, IP_DSCR AS nome_procedimento FROM tb_sigtaw;

-- Indices das tabelas auxiliares
CREATE INDEX idx_cadgerrs_cnes   ON cadgerrs (CNES);
CREATE INDEX idx_sigtaw_ip_cod   ON tb_sigtaw (IP_COD);
CREATE INDEX idx_cbo_cbo         ON cbo (CBO);
CREATE INDEX idx_scid_cd_cod     ON s_cid (CD_COD);
CREATE INDEX idx_municip_cod     ON tb_municip (cod_municip);
CREATE INDEX idx_micibge_cod     ON tb_micibge (cod_micibge);
CREATE INDEX idx_rl_municip      ON rl_municip_micibge (cod_municip);
CREATE INDEX idx_rl_micibge      ON rl_municip_micibge (cod_micibge);

-- Indices da tabela pars (pode levar alguns minutos)
CREATE INDEX idx_pars_proc_id ON pars (PA_PROC_ID);
CREATE INDEX idx_pars_coduni  ON pars (PA_CODUNI);
CREATE INDEX idx_pars_cbocod  ON pars (PA_CBOCOD);
CREATE INDEX idx_pars_cidpri  ON pars (PA_CIDPRI);

-- Conferencia
SELECT 'cadgerrs' t, COUNT(*) n FROM cadgerrs UNION ALL SELECT 'tb_sigtaw', COUNT(*) FROM tb_sigtaw
UNION ALL SELECT 'cbo', COUNT(*) FROM cbo UNION ALL SELECT 's_cid', COUNT(*) FROM s_cid
UNION ALL SELECT 'tb_municip', COUNT(*) FROM tb_municip UNION ALL SELECT 'tb_micibge', COUNT(*) FROM tb_micibge
UNION ALL SELECT 'rl_municip_micibge', COUNT(*) FROM rl_municip_micibge;

-- Exemplo: producao com nomes (procedimento, ocupacao, CID, estabelecimento, municipio)
SELECT p.PA_CODUNI, e.FANTASIA, m.nome_municip, p.PA_PROC_ID, s.IP_DSCR AS procedimento,
       c.DS_CBO AS ocupacao, d.CD_DESCR AS cid, p.PA_QTDAPR, p.PA_VALAPR
FROM pars p
LEFT JOIN cadgerrs  e ON e.CNES = p.PA_CODUNI
LEFT JOIN tb_municip m ON m.cod_municip = p.PA_UFMUN
LEFT JOIN tb_sigtaw s ON s.IP_COD = p.PA_PROC_ID
LEFT JOIN cbo       c ON c.CBO = p.PA_CBOCOD
LEFT JOIN s_cid     d ON d.CD_COD = p.PA_CIDPRI
LIMIT 10;
