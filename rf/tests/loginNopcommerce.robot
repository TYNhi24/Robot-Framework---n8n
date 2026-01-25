*** Settings ***
Library         SeleniumLibrary
Library         String
Library         DataDriver    file=C:\\n8n_robot_share\\nopcommerce.xlsx    sheet_name=login
Suite Setup     Open App
Suite Teardown  Close Browser
Test Template   Run Steps

*** Keywords ***
Open App
   Open Browser    https://demo.nopcommerce.com/login    chrome    options=add_argument("--disable-blink-features=AutomationControlled")

    Maximize Browser Window
    Set Selenium Timeout    3s
    Set Selenium Implicit Wait    0s
    Wait Until Element Is Visible    name=Email    3s
    Wait Until Element Is Visible    name=Password    3s
Slow Input Text
    [Arguments]    ${locator}    ${text}
    Clear Element Text    ${locator}
    ${chars}=    Split String To Characters    ${text}
    FOR    ${char}    IN    @{chars}
        Press Keys    ${locator}    ${char}
        Sleep    0.2s
    END

Run Steps
    [Arguments]    ${Step1_Keyword}    ${Step1_Arg1}    ${Step1_Arg2}
    ...            ${Step2_Keyword}    ${Step2_Arg1}    ${Step2_Arg2}
    ...            ${Step3_Keyword}    ${Step3_Arg1}    ${Step3_Arg2}
    ...            ${Step4_Keyword}    ${Step4_Arg1}    ${Step4_Arg2}

    Run Keyword If    '${Step1_Keyword}' != ''    Run Step    ${Step1_Keyword}    ${Step1_Arg1}    ${Step1_Arg2}
    Run Keyword If    '${Step2_Keyword}' != ''    Run Step    ${Step2_Keyword}    ${Step2_Arg1}    ${Step2_Arg2}
    Run Keyword If    '${Step3_Keyword}' != ''    Run Step    ${Step3_Keyword}    ${Step3_Arg1}    ${Step3_Arg2}
    Run Keyword If    '${Step4_Keyword}' != ''    Run Step    ${Step4_Keyword}    ${Step4_Arg1}    ${Step4_Arg2}

Run Step
    [Arguments]    ${keyword}    ${arg1}    ${arg2}
    # Sử dụng $arg1 thay vì '${arg1}' để tránh lỗi cú pháp python
    Run Keyword If    $arg1 and $arg2    ${keyword}    ${arg1}    ${arg2}
    ...    ELSE IF    $arg1              ${keyword}    ${arg1}
    ...    ELSE                          ${keyword}
*** Test Cases ***
Execute All Steps From One Row
    [Documentation]    Data-driven by nopcommerce.xlsx (sheet: login)
