*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE}    https://reqres.in/api

*** Test Cases ***
Ping API
    Create Session    s    ${BASE}
    ${resp}=    GET On Session    s    /users/2
    Should Be Equal As Integers    ${resp.status_code}    200
