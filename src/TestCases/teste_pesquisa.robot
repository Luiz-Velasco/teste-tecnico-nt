*** Settings ***
Documentation    Suite de testes automatizados para validar a funcionalidade de pesquisa do Blog do AGI.
...              Cenarios: busca com resultado valido e busca sem resultado.
...              Tecnologia: Robot Framework + SeleniumLibrary

Resource    ../Resources/keywords.robot
Resource    ../Resources/bdd_steps.robot

Test Setup       Abrir Blog
Test Teardown    Fechar Navegador

*** Test Cases ***
Validar pesquisa com sucesso no blog
    [Documentation]    Testa o fluxo positivo da pesquisa.
    ...                Executa uma busca por um termo valido (investimentos)
    ...                e valida que resultados sao exibidos.
    [Tags]    smoke    busca    positivo    high-priority
    Dado que o usuario esta na pagina inicial do blog
    Quando ele fizer uma pesquisa por investimento
    Entao recebera o resultado da pesquisa na tela

Validar pesquisa sem resultado no blog
    [Documentation]    Testa o fluxo negativo da pesquisa.
    ...                Executa uma busca por um termo inexistente (invalido)
    ...                e valida a mensagem de "nada foi encontrado".
    [Tags]    smoke    busca    negativo    high-priority
    Dado que o usuario esta na pagina inicial do blog
    Quando ele fizer uma pesquisa por invalido
    Entao deve ver a mensagem de nenhum resultado
