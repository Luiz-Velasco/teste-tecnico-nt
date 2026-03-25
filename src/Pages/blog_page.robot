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
    Tentar Abrir Busca Via JavaScript
    Aguardar Campo De Busca Pronto

Tentar Abrir Busca Pelo Botao Lupa
    Wait Until Element Is Visible    ${BOTAO_LUPA_BUSCA}    10s
    Scroll Element Into View    ${BOTAO_LUPA_BUSCA}
    Click Element    ${BOTAO_LUPA_BUSCA}

Tentar Abrir Busca Pelo Container
    ${container_visivel}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${CONTAINER_LUPA_BUSCA}    5s
    Run Keyword If    ${container_visivel}    Click Element    ${CONTAINER_LUPA_BUSCA}

Tentar Abrir Busca Via JavaScript
    Execute JavaScript    var cands=document.querySelectorAll("#ast-desktop-header .ast-search-icon, .ast-header-search .ast-search-icon, a.astra-search-icon[aria-label='Search button'], a.astra-search-icon[aria-label='Open search form'], a.slide-search.astra-search-icon"); for (var i=0;i<cands.length;i++){ var el=cands[i]; var r=el.getBoundingClientRect(); var st=window.getComputedStyle(el); if (r.width>0 && r.height>0 && st.visibility!=='hidden' && st.display!=='none'){ el.click(); el.dispatchEvent(new MouseEvent('click',{bubbles:true,cancelable:true,view:window})); break; } }

Aguardar Campo De Busca Pronto
    Wait Until Element Is Visible    ${CAMPO_TEXTO_BUSCA}    10s
    Wait Until Element Is Enabled    ${CAMPO_TEXTO_BUSCA}    10s
    Wait Until Keyword Succeeds    10s    500ms    Campo De Busca Deve Estar Interativo

Campo De Busca Deve Estar Interativo
    ${pronto}=    Execute JavaScript    return (function(){ var el=document.querySelector("div.ast-search-menu-icon.ast-dropdown-active input#search-field, div.ast-search-menu-icon.ast-dropdown-active input[name='s'], div.ast-search-menu-icon.ast-dropdown-active input[type='search']"); if (!el) return 0; var st=window.getComputedStyle(el); var r=el.getBoundingClientRect(); return (r.width > 30 && r.height > 10 && st.display !== 'none' && st.visibility !== 'hidden' && st.opacity !== '0') ? 1 : 0; })();
    Should Be Equal As Integers    ${pronto}    1

Preencher Campo De Busca Com Termo
    [Arguments]    ${termo}
    Aguardar Campo De Busca Pronto
    Click Element    ${CAMPO_TEXTO_BUSCA}
    Clear Element Text    ${CAMPO_TEXTO_BUSCA}
    ${digitou}=    Run Keyword And Return Status    Input Text    ${CAMPO_TEXTO_BUSCA}    ${termo}
    ${campo_input}=    Get WebElement    ${CAMPO_TEXTO_BUSCA}
    Run Keyword If    not ${digitou}    Execute JavaScript    arguments[0].value = arguments[1]; arguments[0].dispatchEvent(new Event('input', {bubbles:true})); arguments[0].dispatchEvent(new Event('change', {bubbles:true}));    ${campo_input}    ${termo}
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
