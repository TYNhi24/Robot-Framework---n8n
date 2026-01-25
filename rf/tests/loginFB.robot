*** Settings ***
#đọc từ excel
# Đường dẫn đã được trỏ thẳng đến file trong thư mục chia sẻ
Library    DataDriver    file=C:\\n8n_robot_share\\demoRobot.xlsx    sheet_name=demoRobot

Library    SeleniumLibrary

Suite Setup    Open Browser To Facebook
Suite Teardown    Close Browser
Test Setup    Go To Login Page
Test Template    Run Single Login Test

*** Variables ***
${URL}    https://www.facebook.com/

*** Keywords ***
Open Browser To Facebook
    Open Browser    ${URL}    chrome
    Maximize Browser Window

Go To Login Page
    Go To    ${URL}

Login With Data
    [Arguments]    ${email}    ${password}
    Input Text    id=email    ${email}
    Input Text    id=pass    ${password}
    Click Button    name=login
    Sleep    2s

Run Single Login Test
    [Arguments]    ${Test_Case_ID}    ${Test_Case_Name}    ${Email}    ${Password}    ${Expected_Result}
    Log    Running: ${Test_Case_ID} - ${Test_Case_Name}
    Login With Data    ${Email}    ${Password}
    Log    Expected: ${Expected_Result}
    # Page Should Contain    ${Expected_Result} # Bỏ comment nếu muốn kiểm tra

*** Test Cases ***
Run Login Scenarios From Excel
    [Documentation]    This test will be expanded by DataDriver
    No Operation