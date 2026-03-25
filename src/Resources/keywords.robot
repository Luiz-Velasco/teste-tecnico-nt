*** Settings ***
Resource    ../Resources/variables.robot
Resource    ../Pages/blog_page.robot
Library     SeleniumLibrary

*** Keywords ***
Abrir Blog
    Open Browser    ${URL_BASE}    ${NAVEGADOR}
    Maximize Browser Window

Fechar Navegador
    Run Keyword And Ignore Error    Capture Page Screenshot
    Close Browser

Buscar Por Termo
    [Arguments]    ${termo}
    Clicar Na Lupa De Busca
    Preencher Campo De Busca Com Termo    ${termo}
    Submeter Busca
    Esperar Carregamento Da Pagina De Resultados

Validar Que Existem Resultados
    ${total_resultados}=    Obter Quantidade De Resultados
    Should Be True    ${total_resultados} > 0

Validar Comportamento Sem Resultados
    ${total_resultados}=    Obter Quantidade De Resultados
    ${mensagem_sem_resultado}=    Mensagem De Sem Resultado Esta Visivel
    ${sem_resultados}=    Evaluate    ${total_resultados} == 0 or ${mensagem_sem_resultado}
    Should Be True    ${sem_resultados}

Validar Mensagem De Nenhum Resultado
    Validar Texto De Nenhum Resultado
