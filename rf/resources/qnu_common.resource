*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
# Chon Dropdown QNU
#     [Arguments]    ${locator_dropdown}    ${value_text}
#     Log To Console    \n--- Đang chọn Dropdown: ${value_text}
#     Click Element    ${locator_dropdown}
#     # Đợi cho đến khi danh sách li xuất hiện để tránh lỗi chạy nhanh quá
#     Wait Until Element Is Visible    xpath://li[.='${value_text}']    timeout=5s
#     Click Element                    xpath://li[.='${value_text}']

Chon Dropdown QNU
    [Arguments]    ${locator_dropdown}    ${value_text}
    Log To Console    \n--- Đang chọn Dropdown: ${value_text}
    
    # Dùng Wait Until Keyword Succeeds để thử lại 3 lần, mỗi lần cách nhau 1 giây nếu bị Stale
    Wait Until Keyword Succeeds    3x    1s    Thuc Thi Click Dropdown    ${locator_dropdown}    ${value_text}

Thuc Thi Click Dropdown
    [Arguments]    ${locator_dropdown}    ${value_text}
    # 1. Click mở dropdown
    Wait Until Element Is Visible    ${locator_dropdown}    timeout=10s
    Click Element                    ${locator_dropdown}
    
    # 2. Chờ một chút ngắn để danh sách kịp render (Tránh Stale ngay lập tức)
    Sleep    0.5s
    
    # 3. Tìm và Click vào item
    ${dynamic_xpath}=    Set Variable    xpath://li[contains(normalize-space(.), '${value_text}')]
    Wait Until Element Is Visible    ${dynamic_xpath}    timeout=7s
    Click Element                    ${dynamic_xpath}

Login QNU
    Click Element	xpath:(//a[contains(text(),'Đăng nhập')])[2]
    Input Text    name:email    4551050152
    Input Text    name:password    1521050455
    Click Button  xpath://button[@type='submit']
    Wait Until Location Contains    /student    10s
# Login QNU
#     Wait Until Element Is Visible    xpath:(//a[contains(text(),'Đăng nhập')])[2]    10s
#     Click Element    xpath:(//a[contains(text(),'Đăng nhập')])[2]
#     Wait Until Element Is Visible    id:username    10s
#     Input Text       id:username    4551050152
#     Input Text       id:password    1521050455
#     Click Button     id:loginBtn
#     # Đợi load xong trang sinh viên mới tính là xong login
#     Wait Until Location Contains    /student    10s