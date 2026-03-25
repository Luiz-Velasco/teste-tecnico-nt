# Automacao de Testes - Busca no Blog do AGI

Projeto de automacao de testes web com Robot Framework e SeleniumLibrary para validar a funcionalidade de busca do site [Blog do AGI](https://blogdoagi.com.br/)

## Tecnologias utilizadas

- Robot Framework
- SeleniumLibrary
- Selenium
- Chrome WebDriver

## Estrutura do projeto

```text
src/
  Pages/
    blog_page.robot
  Resources/
    bdd_steps.robot
    keywords.robot
    variables.robot
  TestCases/
    teste_pesquisa.robot
```

### Responsabilidade de cada arquivo

- `src/Pages/blog_page.robot`:
  - Define locators robustos da pagina de busca
  - Implementa keywords de baixo nivel (acoes de pagina)
- `src/Resources/variables.robot`:
  - Centraliza variaveis globais (URL, navegador, termos de busca)
- `src/Resources/bdd_steps.robot`:
  - Contem os passos BDD reutilizaveis (Dado/Quando/Entao)
- `src/Resources/keywords.robot`:
  - Implementa keywords de alto nivel (fluxo de negocio)
- `src/TestCases/teste_pesquisa.robot`:
  - Contem os cenarios de teste com documentation e tags

## Cenarios cobertos

1. Busca com resultado valido
- Acessa o site
- Abre a busca pela lupa em execucao local
- Pesquisa por `investimentos`
- Valida que existem resultados

2. Busca sem resultado
- Pesquisa por `invalido`
- Valida comportamento sem resultados
- Valida a mensagem de retorno: "nada foi encontrado"

## Estrategia de execucao

- Em execucao local, a automacao interage com a lupa de busca no cabecalho do blog.
- Em CI (GitHub Actions), a automacao utiliza a URL de pesquisa (`?s=termo`) para evitar instabilidade do layout responsivo em modo headless.
- Em ambos os casos, a validacao continua sendo feita sobre a funcionalidade real de pesquisa do blog.

## Variaveis globais (arquivo variables.robot)

- `${URL_BASE}`
- `${NAVEGADOR}`
- `${TERMO_BUSCA_VALIDO}`
- `${TERMO_BUSCA_INEXISTENTE}`

## Boas praticas aplicadas

- Padrao Page Object
- Separacao clara de responsabilidades
- Reutilizacao de keywords
- Separacao dos passos BDD em arquivo dedicado (`bdd_steps.robot`)
- Nao utiliza `Sleep` fixo
- Usa `Wait Until Element Is Visible` e `Wait Until Page Contains Element`
- Locators mais robustos (aria-label, placeholder e xpath confiavel)
- Fallback especifico para CI em ambiente headless
- Evidencia automatica por screenshot ao final de cada teste (teardown)

## Instalacao

1. Crie e ative um ambiente virtual (opcional, recomendado).
2. Instale as dependencias:

```bash
pip install -r requirements.txt
```

## Execucao dos testes

Execute os testes com:

```bash
robot -d results src/TestCases/
```

Ou execute somente a suite principal:

```bash
robot -d results src/TestCases/teste_pesquisa.robot
```

## Observacoes sobre WebDriver

- E necessario ter o Chrome instalado.
- Garanta compatibilidade entre versao do Chrome e ChromeDriver.
- Se preferir, utilize Selenium Manager (versoes atuais do Selenium) para gerenciamento automatico do driver.

## Pipeline CI/CD (GitHub Actions)

O projeto possui pipeline pronta para avaliacao tecnica em:

- `.github/workflows/robot-tests.yml`

Essa pipeline:

- roda apenas em eventos de `pull_request` para `master`
- dispara quando o PR e aberto, atualizado, reaberto ou marcado como pronto para revisao
- instala dependencias Python
- executa os testes Robot em ambiente Linux com navegador Chrome via `xvfb-run`
- utiliza Selenium Manager e configuracao especifica para execucao headless no CI
- publica artefatos `results/report.html`, `results/log.html` e `results/output.xml`

## Como o avaliador pode validar rapidamente

1. Clonar o repositorio.
2. Executar localmente:

```bash
pip install -r requirements.txt
robot -d results src/TestCases/
```

3. Ou validar pela aba Actions do GitHub:

- abrir o workflow `Robot Framework CI`
- abrir ou atualizar um Pull Request para disparar a execucao automaticamente
- baixar os artefatos `robot-reports`
