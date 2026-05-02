*** Settings ***
Library           SeleniumLibrary    run_on_failure=Capture Page Screenshot
Library           DataDriver         file=C:\\n8n_robot_share\\loginqnu.xlsx    
Library           Collections        

Resource          ../resources/schedule_locators.resource
Resource          ../resources/qnu_common.resource

Test Setup        Mo Trinh Duyet QNU
Test Teardown     Dong Trinh Duyet QNU
Test Template     Thuc Thi Kich Ban Tu AI

*** Variables ***
${BROWSER}        chrome
${URL_QNU}        https://daotao.qnu.edu.vn

*** Test Cases ***
Kich ban ${TC_ID} duoc thuc thi tu AI

*** Keywords ***
Thuc Thi Kich Ban Tu AI
    [Arguments]    ${Step1_Keyword}=${EMPTY}    ${Step1_Arg1}=${EMPTY}    ${Step1_Arg2}=${EMPTY}    
    ...            ${Step2_Keyword}=${EMPTY}    ${Step2_Arg1}=${EMPTY}    ${Step2_Arg2}=${EMPTY}    
    ...            ${Step3_Keyword}=${EMPTY}    ${Step3_Arg1}=${EMPTY}    ${Step3_Arg2}=${EMPTY}    
    ...            ${Step4_Keyword}=${EMPTY}    ${Step4_Arg1}=${EMPTY}    ${Step4_Arg2}=${EMPTY}    
    ...            ${Step5_Keyword}=${EMPTY}    ${Step5_Arg1}=${EMPTY}    ${Step5_Arg2}=${EMPTY}    
    ...            ${Step6_Keyword}=${EMPTY}    ${Step6_Arg1}=${EMPTY}    ${Step6_Arg2}=${EMPTY}
    
    # Vòng lặp chạy qua 6 bước (từ 1 đến 6)
    FOR    ${i}    IN RANGE    1    7
        # Sử dụng dấu backslash (\) trước $ để lấy giá trị biến động theo chỉ số i
        ${k}=     Get Variable Value    \${Step${i}_Keyword}    ${EMPTY}
        ${a1}=    Get Variable Value    \${Step${i}_Arg1}       ${EMPTY}
        ${a2}=    Get Variable Value    \${Step${i}_Arg2}       ${EMPTY}
        
        # Nếu Keyword không trống thì mới thực hiện
        Run Keyword If    '${k}' != '${EMPTY}'    Thuc Thi Step Chuyen Nghiep    ${k}    ${a1}    ${a2}
    END

Thuc Thi Step Chuyen Nghiep
    [Arguments]    ${keyword}    ${arg1}    ${arg2}
    
    ${final_arg1}=    Replace Variables    ${arg1}
    ${final_arg2}=    Replace Variables    ${arg2}

    Log To Console    \n--- Đang chạy: ${keyword} | A1: ${final_arg1} | A2: ${final_arg2}

    # KIỂM TRA ĐẶC BIỆT CHO INPUT TEXT
    IF    '${keyword}' == 'Input Text'
        # Nếu Arg2 bị trống (do AI sinh lỗi), ta dùng tạm Arg1 nhưng báo lỗi rõ ràng
        # Hoặc ép buộc truyền cả 2 biến dù Arg2 có rỗng hay không
        Run Keyword    Input Text    ${final_arg1}    ${final_arg2}
    
    ELSE IF    '${keyword}' == 'Wait Until Element Is Visible'
        # Wait cũng thường cần 2 tham số (Locator và Timeout)
        Run Keyword    Wait Until Element Is Visible    ${final_arg1}    ${final_arg2}

    ELSE
        # Các keyword khác (Click, Page Should Contain...) dùng list linh hoạt
        @{list_args}=    Create List
        IF    "${final_arg1}" != ""    Append To List    ${list_args}    ${final_arg1}
        IF    "${final_arg2}" != ""    Append To List    ${list_args}    ${final_arg2}
        Run Keyword    ${keyword}    @{list_args}
    END
    
Mo Trinh Duyet QNU
    Open Browser    ${URL_QNU}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    5s    

Dong Trinh Duyet QNU
    Close Browser