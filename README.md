# Análise de dados do SIASUS para apoio à gestão municipal de saúde (Ijuí/RS)

Trabalho T3: carga do SIASUS (DATASUS) em MySQL, análise com Pandas e visualização em Python, para apoiar a Secretaria Municipal de Saúde de Ijuí/RS.

**Integrantes:** Arthur Pereira e Julia Schafer

## Fontes e período analisado

| Item | Detalhe |
|---|---|
| Produção ambulatorial | `PARS2607` (SIA-SUS, arquivo PA, RS), competência **julho de 2026** |
| Tabelas auxiliares | `TAB_SIA` (CADGERRS, CBO, S_CID, TB_SIGTAW e tabelas de município/microrregião IBGE) |
| Origem | Repositório de dados do DATASUS (arquivos `.dbc`) |
| Município analisado | Ijuí/RS, código IBGE `431020` |

Somente uma competência está carregada. Por isso a evolução temporal (picos e quedas) tem um único ponto até que outros meses sejam importados.

## Estrutura da pasta

| Arquivo | Função |
|---|---|
| `sql/create_pars.sql` | Cria o banco `dbsia` e a tabela `pars` |
| `sql/load.sql` | Importa `PARS2607.csv` na tabela `pars` com `LOAD DATA LOCAL INFILE` |
| `sql/create_auxiliares.sql` | Cria e carrega as tabelas auxiliares, a VIEW `procedimentos` e os índices |
| `notebooks/producaoTrabalhoDBsia.ipynb` | Notebook final: exploração, limpeza, análises, gráficos e interpretação |
| `notebooks/Etapas 2 e 3 - Pandas e Visualizacao - DBSIA.ipynb` | Versão guiada das Aulas 2 e 3 (modelo da disciplina) |
| `csv/`, `PARS2607.csv`, `TAB_SIA/` | Dados (não versionar); os scripts SQL apontam para estes caminhos |
| `Exemplos/` | Material de apoio da disciplina (exemplos de Matplotlib e Seaborn) |

Os arquivos grandes (`PARS2607.dbc`, `.dbf`, `.csv`, com 0,15 a 1,9 GB) e a pasta `TAB_SIA/` não devem ser versionados no Git. Baixe-os conforme os passos abaixo.

## Pré-requisitos

- MySQL 8 ou superior, com `local_infile` habilitado
- Python 3.10 ou superior
- Bibliotecas: `pandas`, `mysql-connector-python`, `matplotlib`, `seaborn`, `jupyter`

```bash
pip install pandas mysql-connector-python matplotlib seaborn jupyter
```

## Como reproduzir

### 1. Obter e converter os dados (Aula 1)

1. Baixe do DATASUS o arquivo `PARS2607.dbc` e as tabelas auxiliares (`TAB_SIA`).
2. Converta `.dbc` para `.dbf` com o TABWIN.
3. Exporte para CSV (`PARS2607.csv`, separador `;`, e os CSVs das auxiliares na pasta `csv/`).

### 2. Criar e carregar o banco

Ajuste os caminhos absolutos dentro de `load.sql` e `create_auxiliares.sql` para a sua máquina e rode, nesta ordem, com o cliente de linha de comando:

```bash
mysql --local-infile=1 -u root -p
```

```sql
source sql/create_pars.sql;
source sql/load.sql;
source sql/create_auxiliares.sql;
```


### 3. Executar as análises (Aulas 2 e 3)

```bash
jupyter notebook notebooks/producaoTrabalhoDBsia.ipynb
```

O notebook pede a senha do MySQL (`getpass`) e lê os dados da VIEW `pa_ijui`.

## Conteúdo das análises

1. Exploração: dimensão, tipos, estatísticas descritivas, nulos e valores inválidos.
2. Limpeza: tratamento de nulos ("Não informado") e remoção de duplicatas.
3. Volume e perfil dos procedimentos.
4. Produção por estabelecimento (apresentado x aprovado).
5. Perfil demográfico e epidemiológico (sexo, faixa etária, CID).
6. Fluxos regionais (município de residência dos pacientes).
7. Recursos financeiros (valor produzido x aprovado).
8. Áreas críticas: oncologia, saúde mental e atenção básica.
9. Perguntas do gestor: emergências, cirurgias, atendimento básico, origem e faixa etária, glosas.

## Limitações conhecidas

- Apenas a competência 2026-07 está carregada.
