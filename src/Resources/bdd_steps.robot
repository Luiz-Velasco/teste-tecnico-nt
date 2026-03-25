*** Settings ***
Resource    ../Resources/keywords.robot
Resource    ../Resources/variables.robot

*** Keywords ***
Dado que o usuario esta na pagina inicial do blog
    No Operation

Quando ele fizer uma pesquisa por investimento
    Buscar Por Termo    ${TERMO_BUSCA_VALIDO}

Entao recebera o resultado da pesquisa na tela
    Validar Que Existem Resultados

Quando ele fizer uma pesquisa por invalido
    Buscar Por Termo    ${TERMO_BUSCA_INEXISTENTE}

Entao deve ver a mensagem de nenhum resultado
    Validar Comportamento Sem Resultados
    Validar Mensagem De Nenhum Resultado
