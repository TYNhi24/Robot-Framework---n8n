*** Settings ***
Library           SeleniumLibrary    run_on_failure=Capture Page Screenshot
Library           DataDriver         file=C:\\n8n_robot_share\\test.xlsx  sheet_name=${SHEET_NAME}
Library           Collections        # Thêm thư viện Collections để xử lý danh sách tham số

Resource          ../resources/schedule_locators.resource
Resource          ../resources/qnu_common.resource

Test Setup        Mo Trinh Duyet QNU
Test Teardown     Dong Trinh Duyet QNU
Test Template     Xu Ly Kich Ban Kiem Thu

*** Variables ***
${BROWSER}        chrome
${URL_QNU}        https://daotao.qnu.edu.vn
${SHEET_NAME}     default
*** Test Cases ***
Thuc thi Kich Ban Kiem Thu ${TC_ID}

*** Keywords ***
Xu Ly Kich Ban Kiem Thu
    [Arguments]    ${Step1_Keyword}    ${Step1_Arg1}    ${Step1_Arg2}    
    ...            ${Step2_Keyword}    ${Step2_Arg1}    ${Step2_Arg2}    
    ...            ${Step3_Keyword}    ${Step3_Arg1}    ${Step3_Arg2}    
    ...            ${Step4_Keyword}    ${Step4_Arg1}    ${Step4_Arg2}    
    ...            ${Step5_Keyword}    ${Step5_Arg1}    ${Step5_Arg2}    
    ...            ${Step6_Keyword}    ${Step6_Arg1}    ${Step6_Arg2}
    
    FOR    ${i}    IN RANGE    1    7
        ${k}=     Get Variable Value    \${Step${i}_Keyword}    ${EMPTY}
        ${a1}=    Get Variable Value    \${Step${i}_Arg1}       ${EMPTY}
        ${a2}=    Get Variable Value    \${Step${i}_Arg2}       ${EMPTY}
        
        Run Keyword If    '${k}' != '${EMPTY}'    Thuc Thi Buoc Kiem Thu    ${k}    ${a1}    ${a2}
    END

Thuc Thi Buoc Kiem Thu
    [Arguments]    ${keyword}    ${arg1}    ${arg2}
    
    ${final_arg1}=    Replace Variables    ${arg1}
    ${final_arg2}=    Replace Variables    ${arg2}

    Log To Console    \n--- Đang chạy: ${keyword} | Arg1: ${final_arg1}

    @{args}=    Create List
    
    IF    $final_arg1 != ""
        Append To List    ${args}    ${final_arg1}
    END
    
    IF    $final_arg2 != ""
        Append To List    ${args}    ${final_arg2}
    END

    Run Keyword    ${keyword}    @{args}


Mo Trinh Duyet QNU
    Open Browser    ${URL_QNU}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    5s    # Thêm thời gian chờ ngầm định cho toàn bộ project

Dong Trinh Duyet QNU
    Close Browser