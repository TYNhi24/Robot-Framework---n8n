*** Settings ***
Library           SeleniumLibrary    run_on_failure=None
Library           DataDriver         file=C:\\n8n_robot_share\\loginqnu.xlsx    sheet_name=Bản sao của loginqnu
Test Setup        Mo Trinh Duyet QNU
Test Teardown     Dong Trinh Duyet QNU
Test Template     Template Dang Nhap QNU

*** Variables ***
${BROWSER}           chrome
${URL_QNU}           https://daotao.qnu.edu.vn
${BTN_GOTO_LOGIN}    xpath://a[contains(text(),'Đăng nhập')]
${TXT_USERNAME}      id::r1:
${TXT_PASSWORD}      id::r2:
${BTN_LOGIN}         xpath://button[contains(text(),'Đăng nhập')]
${PAGE_TITLE}        Trang quản lý đào tạo

*** Test Cases ***
Dang nhap cho nhieu tai khoan bang file Excel
    [Documentation]    Kịch bản này sẽ tự động lặp lại cho từng dòng dữ liệu trong file Excel.
    # Tên Test Case thực tế sẽ được DataDriver thay thế bằng nội dung trong file Excel

*** Keywords ***
Template Dang Nhap QNU
    [Arguments]    ${username}    ${password}
    Di Toi Trang Dang Nhap
    Nhap Tai Khoan    ${username}
    Nhap Mat Khau     ${password}
    Click Nut Dang Nhap
    Kiem Tra Dang Nhap Thanh Cong

Di Toi Trang Dang Nhap
    [Documentation]    Click nút Đăng nhập trên Header để mở form Login
    Wait Until Element Is Visible    ${BTN_GOTO_LOGIN}    5s
    Click Element    ${BTN_GOTO_LOGIN}
    Wait Until Element Is Visible    ${TXT_USERNAME}      5s

Nhap Tai Khoan
    [Arguments]    ${username}
    Wait Until Element Is Visible    ${TXT_USERNAME}    5s
    Input Text    ${TXT_USERNAME}    ${username}

Nhap Mat Khau
    [Arguments]    ${password}
    Input Password    ${TXT_PASSWORD}    ${password}

Click Nut Dang Nhap
    Click Button    ${BTN_LOGIN}

Kiem Tra Dang Nhap Thanh Cong
    Wait Until Page Contains Element    xpath://a[@href='/Home/info']    5s

Mo Trinh Duyet QNU
    Open Browser    ${URL_QNU}    ${BROWSER}
    Maximize Browser Window
    Set Screenshot Directory    Results/screenshots

Dong Trinh Duyet QNU
    # Chỉ chụp ảnh nếu bài test thất bại để tiết kiệm bộ nhớ
    Run Keyword If Test Failed    Thuc Hien Chup Anh Loi
    Close Browser

Thuc Hien Chup Anh Loi
    Sleep    2s    # Đợi thông báo lỗi hiển thị rõ ràng
    Capture Page Screenshot    ${TEST_NAME}_failure.png