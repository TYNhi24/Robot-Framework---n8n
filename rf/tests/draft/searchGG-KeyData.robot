*** Settings ***
Library           SeleniumLibrary    run_on_failure=None
Library           DataDriver         file=C:\\n8n_robot_share\\loginqnu.xlsx    sheet_name=ggsearch
Test Setup        Mo Trinh Duyet QNU
Test Teardown     Dong Trinh Duyet QNU
Test Template     Thuc Thi Kich Ban Tu AI

*** Variables ***
${BROWSER}        edge
${URL_QNU}        https://www.google.com/

*** Test Cases ***
Kich ban ${TC_ID} duoc thuc thi tu AI

*** Keywords ***
Thuc Thi Kich Ban Tu AI
    [Arguments]    ${Step1_Keyword}    ${Step1_Arg1}    ${Step1_Arg2}    
    ...            ${Step2_Keyword}    ${Step2_Arg1}    ${Step2_Arg2}    
    ...            ${Step3_Keyword}    ${Step3_Arg1}    ${Step3_Arg2}    
    ...            ${Step4_Keyword}    ${Step4_Arg1}    ${Step4_Arg2}    
    ...            ${Step5_Keyword}    ${Step5_Arg1}    ${Step5_Arg2}    
    ...            ${Step6_Keyword}    ${Step6_Arg1}    ${Step6_Arg2}
    
    # Kỹ thuật chuyên gia: Dùng vòng lặp động để quét sạch 6 bước
    FOR    ${i}    IN RANGE    1    7
        # Sử dụng Get Variable Value để tránh lỗi nếu cột trong Excel bị thiếu
        ${k}=    Get Variable Value    \${Step${i}_Keyword}    ${EMPTY}
        ${a1}=   Get Variable Value    \${Step${i}_Arg1}       ${EMPTY}
        ${a2}=   Get Variable Value    \${Step${i}_Arg2}       ${EMPTY}
        
        # Chỉ chạy nếu Keyword không rỗng
        Run Keyword If    '${k}' != '${EMPTY}'    Thuc Thi Step    ${k}    ${a1}    ${a2}
    END

Thuc Thi Step
    [Arguments]    ${keyword}    ${arg1}    ${arg2}
    Log To Console    \n[EXEC] ${keyword} | ${arg1} | ${arg2}

    # Xử lý các keyword cần chờ đợi (Assertion)
    IF    'Wait Until' in $keyword
        Run Keyword    ${keyword}    ${arg1}    ${arg2}
    
    # Xử lý nhập liệu và các phím chức năng (Enter, Tab...)
    ELSE IF    'Input' in $keyword or 'Press Keys' in $keyword
        Run Keyword    ${keyword}    ${arg1}    ${arg2}

    # Xử lý kiểm tra nội dung text (Negative Cases)
    ELSE IF    'Page Should Contain' == $keyword
        Log To Console    \n[CHECK] Dang kiem tra thong bao: ${arg1}
        Wait Until Page Contains    ${arg1}    timeout=10s
        Page Should Contain    ${arg1}

    # Các trường hợp click hoặc keyword 1 tham số
    ELSE IF    $arg2 == '' and $arg1 != ''
        Run Keyword    ${keyword}    ${arg1}
    
    # Các trường hợp 2 tham số khác
    ELSE IF    $arg1 != '' and $arg2 != ''
        Run Keyword    ${keyword}    ${arg1}    ${arg2}
    
    ELSE
        Run Keyword    ${keyword}
    END
Mo Trinh Duyet QNU
    Open Browser    ${URL_QNU}    ${BROWSER}
    Maximize Browser Window
    Set Screenshot Directory    Results/screenshots

Dong Trinh Duyet QNU
    Run Keyword If Test Failed    Thuc Hien Chup Anh Loi
    Close Browser

Thuc Hien Chup Anh Loi
    Sleep    1s
    Capture Page Screenshot    ${TEST_NAME}_failure.png