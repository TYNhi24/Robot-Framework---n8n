*** Settings ***
Library           SeleniumLibrary    run_on_failure=Nothing
Library           DataDriver         file=C:\\n8n_robot_share\\test.xlsx  sheet_name=${SHEET_NAME}
Library           Collections        # Thêm thư viện Collections để xử lý danh sách tham số

Resource          ../resources/schedule_locators.resource
Resource          ../resources/qnu_common.resource

Test Setup        Mo Trinh Duyet 
Test Teardown     Dong Trinh Duyet
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
        ${k}=     Get Variable Value    \${Step${i}_Keyword}
        ${a1}=    Get Variable Value    \${Step${i}_Arg1}
        ${a2}=    Get Variable Value    \${Step${i}_Arg2}

        IF    $k
            Log To Console    \n=== Step ${i}: ${k} ===
            Thuc Thi Buoc Kiem Thu    ${k}    ${a1}    ${a2}
        END
    END

Thuc Thi Buoc Kiem Thu
    [Arguments]    ${keyword}    ${arg1}    ${arg2}

    # 1. Kiểm tra keyword có tồn tại không bằng cấu trúc IF mới
    ${exists}=    Run Keyword And Return Status    Keyword Should Exist    ${keyword}
    IF    not ${exists}
        Fail    Keyword không tồn tại: ${keyword}
    END

 # 2. Xử lý tham số
    ${final_arg1}=    Replace Variables    ${arg1}
    ${final_arg2}=    Replace Variables    ${arg2}

    @{args}=    Create List

    # CHỈ Append nếu giá trị KHÔNG RỖNG
    IF    $final_arg1 != "" and $arg1 is not None
        Append To List    ${args}    ${final_arg1}
    END

    IF    $final_arg2 != "" and $arg2 is not None
        Append To List    ${args}    ${final_arg2}
    END

    # 3. Thực thi keyword với khối TRY...EXCEPT
    # 3. Thực thi keyword với cơ chế tự động thử lại nếu phần tử bị "cũ" (Stale)
    TRY
        Wait Until Keyword Succeeds    3x    1s    Run Keyword    ${keyword}    @{args}
        Log    PASS: ${keyword}
    EXCEPT    AS    ${error}
        Capture Page Screenshot    filename=${TEST NAME}_failed_at_${keyword}.png
        Log    FAIL: ${keyword} - Error: ${error}
        Fail    Step failed: ${keyword}
    END

Mo Trinh Duyet 
    Open Browser    ${URL_QNU}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    5s    

Dong Trinh Duyet 
    Close Browser