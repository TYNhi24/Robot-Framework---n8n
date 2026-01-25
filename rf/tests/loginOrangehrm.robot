*** Settings ***
Library         SeleniumLibrary
Library         DataDriver    file=C:\\n8n_robot_share\\orangehrm.xlsx    sheet_name=login
Suite Setup     Open App
Suite Teardown  Close Browser

*** Keywords ***
Open App
    Open Browser    https://opensource-demo.orangehrmlive.com/    chrome
    Maximize Browser Window
    Set Selenium Timeout    35s
    Set Selenium Implicit Wait    0s
    # Wait chung tối thiểu để trang ổn định (không đặc thù OrangeHRM)
    Wait Until Page Contains Element    css=body    35s

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
    Run Keyword If    '${arg1}'!='' and '${arg2}'!=''    ${keyword}    ${arg1}    ${arg2}
    ...    ELSE IF    '${arg1}'!=''                      ${keyword}    ${arg1}
    ...    ELSE                                          ${keyword}

*** Test Cases ***
Execute All Steps From One Row
    [Template]    Run Steps
