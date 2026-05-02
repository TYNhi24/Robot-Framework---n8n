*** Settings ***
Documentation     Bộ khung kiểm thử tự động theo từ khóa (Keyword-Driven) kết hợp Data-Driven.
Library           SeleniumLibrary    run_on_failure=Capture Page Screenshot
Library           DataDriver         file=C:\\n8n_robot_share\\testcase.xlsx  sheet_name=${SHEET_NAME}
Library           Collections

Test Setup        Mo Trinh Duyet QNU
Test Teardown     Dong Trinh Duyet QNU
Test Template     Thuc Thi Kich Ban Tu Dong

*** Variables ***
${BROWSER}        chrome
${URL_QNU}        https://daotao.qnu.edu.vn
${TIMEOUT}        10s

*** Test Cases ***
# Test Case này sẽ lặp lại cho từng dòng trong file Excel
Kich ban ${TC_ID} thuc thi tu du lieu Excel    Default_ID

*** Keywords ***
Thuc Thi Kich Ban Tu Dong
    [Arguments]    ${Step1_K}=${EMPTY}    ${Step1_A1}=${EMPTY}    ${Step1_A2}=${EMPTY}
    ...            ${Step2_K}=${EMPTY}    ${Step2_A1}=${EMPTY}    ${Step2_A2}=${EMPTY}
    ...            ${Step3_K}=${EMPTY}    ${Step3_A1}=${EMPTY}    ${Step3_A2}=${EMPTY}
    ...            ${Step4_K}=${EMPTY}    ${Step4_A1}=${EMPTY}    ${Step4_A2}=${EMPTY}
    ...            ${Step5_K}=${EMPTY}    ${Step5_A1}=${EMPTY}    ${Step5_A2}=${EMPTY}
    ...            ${Step6_K}=${EMPTY}    ${Step6_A1}=${EMPTY}    ${Step6_A2}=${EMPTY}

    # Gom nhóm các bước vào một danh sách để xử lý vòng lặp gọn hơn
    # Mỗi item là một danh sách con: [Keyword, Arg1, Arg2]
    @{all_steps}=    Create List
    ...    ${{['${Step1_K}', '${Step1_A1}', '${Step1_A2}']}}
    ...    ${{['${Step2_K}', '${Step2_A1}', '${Step2_A2}']}}
    ...    ${{['${Step3_K}', '${Step3_A1}', '${Step3_A2}']}}
    ...    ${{['${Step4_K}', '${Step4_A1}', '${Step4_A2}']}}
    ...    ${{['${Step5_K}', '${Step5_A1}', '${Step5_A2}']}}
    ...    ${{['${Step6_K}', '${Step6_A1}', '${Step6_A2}']}}

    FOR    ${step}    IN    @{all_steps}
        ${k}=     Set Variable    ${step[0]}
        ${a1}=    Set Variable    ${step[1]}
        ${a2}=    Set Variable    ${step[2]}
        
        # Nếu Keyword rỗng thì bỏ qua bước đó
        Continue For Loop If    '${k}' == '${EMPTY}' or '${k}' == 'None'
        
        Thuc Thi Step Tuy Chinh    ${k}    ${a1}    ${a2}
    END

Thuc Thi Step Tuy Chinh
    [Arguments]    ${keyword}    ${arg1}    ${arg2}
    Log To Console    \n[EXEC] Running: ${keyword} | ${arg1} | ${arg2}
    
    # Tạo danh sách đối số thực tế (loại bỏ các đối số rỗng)
    @{params}=    Create List
    IF    '${arg1}' != '${EMPTY}' and '${arg1}' != 'None'    Append To List    ${params}    ${arg1}
    IF    '${arg2}' != '${EMPTY}' and '${arg2}' != 'None'    Append To List    ${params}    ${arg2}

    # Sử dụng Run Keyword And Ignore Error nếu bạn muốn test tiếp khi 1 bước lỗi 
    # Hoặc dùng Run Keyword mặc định để dừng ngay khi có lỗi.
    Run Keyword    ${keyword}    @{params}

Mo Trinh Duyet QNU
    Open Browser    ${URL_QNU}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    0.2s    # Giúp quan sát kịp các bước chạy
    Set Selenium Implicit Wait    ${TIMEOUT}

Dong Trinh Duyet QNU
    Close Browser