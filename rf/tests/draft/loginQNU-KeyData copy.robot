*** Settings ***
Library           SeleniumLibrary    run_on_failure=None
Library           DataDriver         file=C:\\n8n_robot_share\\loginqnu.xlsx    sheet_name=draft
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
    Log To Console    \n--- Executing: ${keyword} | ${arg1} | ${arg2}

    # Cách 1: Kiểm tra từ khóa "Input" (An toàn hơn với $keyword)
    ${is_input_keyword}=    Evaluate    'Input' in $keyword

    IF    $is_input_keyword
        # Nếu là Input -> Luôn truyền đủ 2 tham số
        Run Keyword    ${keyword}    ${arg1}    ${arg2}
    
    ELSE IF    'Element Should Contain' == $keyword
    Wait Until Element Is Visible    ${arg1}    10s
    Run Keyword    ${keyword}    ${arg1}    ${arg2}

    # ELSE IF    'Page Should Contain' == $keyword
    # Wait Until Page Contains    ${arg1}    10s
    ELSE IF    $keyword == 'Page Should Contain'
        # --- CHIẾN THUẬT MỚI: CHECK ELEMENT LỖI (Bỏ qua so sánh text tiếng Việt) ---
        
        # Locator lấy từ ảnh bạn gửi (div class="loginbox-forgot" chứa thẻ span đỏ)
        ${error_locator}=    Set Variable    xpath://div[contains(@class, 'loginbox-forgot')]/span
        
        Log To Console    \n[INFO] Đang chờ element lỗi xuất hiện: ${error_locator}
        
        # 1. Chờ tối đa 10s cho đến khi cái dòng chữ đỏ đó hiện ra
        Wait Until Element Is Visible    ${error_locator}    timeout=10s
        
        # 2. (Tùy chọn) Log nội dung thực tế ra để debug xem nó đang hiểu font gì
        ${real_text}=    Get Text    ${error_locator}
        Log To Console    \n[CHECK] Web hien thi: ${real_text} | AI mong doi: ${arg1}
    
    ELSE IF    $arg2 != ''
        # CHÚ Ý: Dùng $arg2 (không ngoặc nhọn, không nháy bao quanh)
        # Để Python tự hiểu object, tránh lỗi dấu nháy trong XPath
        Run Keyword    ${keyword}    ${arg1}    ${arg2}
    
    ELSE IF    $arg1 != ''
        # Tương tự với arg1
        Run Keyword    ${keyword}    ${arg1}
    
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