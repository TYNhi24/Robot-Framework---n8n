*** Settings ***
Library           SeleniumLibrary    run_on_failure=Nothing
Library           DataDriver         file=C:\\n8n_robot_share\\TCQNU.xlsx  sheet_name=${SHEET_NAME}
Library           Collections        

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
    ...            ${Step7_Keyword}    ${Step7_Arg1}    ${Step7_Arg2}
    ...            ${Step8_Keyword}    ${Step8_Arg1}    ${Step8_Arg2}
    ...            ${Step9_Keyword}    ${Step9_Arg1}    ${Step9_Arg2}

    # Chỉnh RANGE thành 1 đến 10 để lặp đủ 9 bước
    FOR    ${i}    IN RANGE    1    10
        ${k}=     Get Variable Value    \${Step${i}_Keyword}
        ${a1}=    Get Variable Value    \${Step${i}_Arg1}
        ${a2}=    Get Variable Value    \${Step${i}_Arg2}

        # Kiểm tra nếu Keyword không rỗng và không phải là None (do DataDriver)
        IF    $k != "" and $k is not None
            Log To Console    \n--- Buoc ${i}: ${k} ---
            Thuc Thi Buoc Kiem Thu    ${k}    ${a1}    ${a2}
        END
    END

Thuc Thi Buoc Kiem Thu
    [Arguments]    ${keyword}    ${arg1}    ${arg2}

    ${exists}=    Run Keyword And Return Status    Keyword Should Exist    ${keyword}
    IF    not ${exists}
        Fail    Keyword không tồn tại: ${keyword}
    END

    ${final_arg1}=    Replace Variables    ${arg1}
    ${final_arg2}=    Replace Variables    ${arg2}

    @{args}=    Create List
    
    # Arg1 (Locator): Bắt buộc phải có giá trị hợp lệ
    IF    "${arg1}" != "None" and "${arg1}" != "nan" and "${arg1}" != "${EMPTY}"
        ${final_arg1}=    Replace Variables    ${arg1}
        Append To List    ${args}    ${final_arg1}
    END

    # Arg2 (Value): Xử lý để không bị mất tham số khi muốn nhập/kiểm tra rỗng
    ${is_empty_val}=    Evaluate    $arg2 is None or str($arg2).lower() == 'nan' or str($arg2) == ''
    
    IF    $is_empty_val
        # Nếu là các từ khóa cần 2 tham số nhưng muốn để rỗng, ta ép thêm ${EMPTY}
        ${need_second_arg}=    Evaluate    $keyword in ['Input Text', 'Textfield Value Should Be', 'Element Text Should Be']
        IF    $need_second_arg
            Append To List    ${args}    ${EMPTY}
        END
    ELSE
        ${final_arg2}=    Replace Variables    ${arg2}
        Append To List    ${args}    ${final_arg2}
    END

    Log    THUC THI: ${keyword} | ARGS: ${args}
    
    TRY
        Run Keyword    ${keyword}    @{args}
    EXCEPT    AS    ${error}
        Capture Page Screenshot    filename=${TEST NAME}_failed_at_${keyword}.png
        Fail    Dừng tại bước: ${keyword} do lỗi: ${error}
    END

Mo Trinh Duyet 
    Open Browser    ${URL_QNU}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    5s    

Dong Trinh Duyet 
    Close Browser