*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BOTAO_LUPA_BUSCA}        xpath=//a[(@aria-label='Search button' or @aria-label='Open search form') and contains(@class,'astra-search-icon')]
${CONTAINER_LUPA_BUSCA}    xpath=//div[contains(@class,'ast-search-icon')]
${CAMPO_TEXTO_BUSCA}       xpath=//div[contains(@class,'ast-search-menu-icon') and contains(@class,'ast-dropdown-active')]//input[@id='search-field' or @name='s' or @type='search']
${BOTAO_ENVIAR_BUSCA}      xpath=//div[contains(@class,'ast-search-menu-icon') and contains(@class,'ast-dropdown-active')]//button[@type='submit' or contains(@class,'search-submit')]
${ITENS_RESULTADO_BUSCA}   css=main article
${MENSAGEM_SEM_RESULTADO}  xpath=//*[contains(.,'Nenhum resultado') or contains(.,'nenhum resultado') or contains(.,'Nada foi encontrado') or contains(.,'nada encontrado') or contains(.,'No results') or contains(.,'no results')]

*** Keywords ***
Clicar Na Lupa De Busca
    ${campo_visivel}=    Run Keyword And Return Status    Element Should Be Visible    ${CAMPO_TEXTO_BUSCA}
    Run Keyword If    ${campo_visivel}    Return From Keyword
    Tentar Abrir Busca Pelo Botao Lupa
    ${abriu}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${CAMPO_TEXTO_BUSCA}    2s
    Run Keyword If    ${abriu}    Return From Keyword
    Tentar Abrir Busca Pelo Container
    ${abriu}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${CAMPO_TEXTO_BUSCA}    2s
    Run Keyword If    ${abriu}    Return From Keyword
    Aguardar Campo De Busca Pronto

Tentar Abrir Busca Pelo Botao Lupa
    Wait Until Element Is Visible    ${BOTAO_LUPA_BUSCA}    10s
    Scroll Element Into View    ${BOTAO_LUPA_BUSCA}
    Click Element    ${BOTAO_LUPA_BUSCA}

Tentar Abrir Busca Pelo Container
    ${container_visivel}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${CONTAINER_LUPA_BUSCA}    5s
    Run Keyword If    ${container_visivel}    Click Element    ${CONTAINER_LUPA_BUSCA}

Aguardar Campo De Busca Pronto
    Wait Until Element Is Visible    ${CAMPO_TEXTO_BUSCA}    10s
    Wait Until Element Is Enabled    ${CAMPO_TEXTO_BUSCA}    10s

Preencher Campo De Busca Com Termo
    [Arguments]    ${termo}
    Aguardar Campo De Busca Pronto
    Click Element    ${CAMPO_TEXTO_BUSCA}
    Clear Element Text    ${CAMPO_TEXTO_BUSCA}
    Input Text    ${CAMPO_TEXTO_BUSCA}    ${termo}
    Textfield Value Should Be    ${CAMPO_TEXTO_BUSCA}    ${termo}

Submeter Busca
    ${botao_visivel}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${BOTAO_ENVIAR_BUSCA}    5s
    Run Keyword If    ${botao_visivel}    Click Element    ${BOTAO_ENVIAR_BUSCA}
    Run Keyword If    not ${botao_visivel}    Press Keys    ${CAMPO_TEXTO_BUSCA}    ENTER

Esperar Carregamento Da Pagina De Resultados
    Wait Until Page Contains Element    //main    10s

Obter Quantidade De Resultados
    ${total}=    Get Element Count    ${ITENS_RESULTADO_BUSCA}
    RETURN    ${total}

Mensagem De Sem Resultado Esta Visivel
    ${visivel}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${MENSAGEM_SEM_RESULTADO}
    ...    10s
    RETURN    ${visivel}

Validar Texto De Nenhum Resultado
    Wait Until Page Contains    nada foi encontrado    10s
