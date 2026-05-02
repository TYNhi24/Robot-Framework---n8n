*** Settings ***
Library         SeleniumLibrary
Library         DataDriver    file=C:\\n8n_robot_share\\demo1011.xlsx    sheet_name=keyw
Suite Setup     Open Browser    https://www.facebook.com/    chrome
Suite Teardown  Close Browser

*** Keywords ***
Execute Step
    [Arguments]    ${Test_Case_ID}    ${Step}    ${Keyword_To_Run}    ${Argument_1}    ${Argument_2}

    Log    Running TC: ${Test_Case_ID} | Step: ${Step} | Keyword: ${Keyword_To_Run} | Arg1: ${Argument_1} | Arg2: ${Argument_2}

    # Logic: 
    # - Nếu Arg2 có giá trị, chạy keyword với cả 2 Arg
    # - Nếu Arg2 rỗng nhưng Arg1 có giá trị, chạy keyword với 1 Arg
    # - Nếu cả 2 đều rỗng, chạy keyword không có Arg
    Run Keyword If    '${Argument_2}' != ''    ${Keyword_To_Run}    ${Argument_1}    ${Argument_2}
    ...    ELSE IF    '${Argument_1}' != ''    ${Keyword_To_Run}    ${Argument_1}
    ...    ELSE    ${Keyword_To_Run}
    
*** Test Cases ***
Execute Scenario From Excel
    [Template]    Execute Step