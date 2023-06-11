# Testing same UI as api.robot but separate file for different testing structure (template style) to reduce duplication for the Collapse param testing 


*** Settings ***
Resource    _api_shared.robot

Test Template    Run CollapseFirstAndLast Tests


*** Keywords ***

Run CollapseFirstAndLast Tests
    [Arguments]    ${invalid_value}    ${valid_value}    ${default_value}
    ${invalid_first_response}=    GET  %{HOST}/mementos/cdx  params=url=${TEST_URL}&collapseToFirst=${invalid_value}  expected_status=422
    ${valid_first_response}=    GET  %{HOST}/mementos/cdx  params=url=${TEST_URL}&collapseToFirst=${valid_value}  expected_status=200
    ${valid_first_default}=    GET  %{HOST}/mementos/cdx  params=url=${TEST_URL}&collapseToLast=${default_value}  expected_status=200
    ${invalid_last_response}=    GET  %{HOST}/mementos/cdx  params=url=${TEST_URL}&collapseToLast=${invalid_value}  expected_status=422
    ${valid_last_response}=    GET  %{HOST}/mementos/cdx  params=url=${TEST_URL}&collapseToLast=${valid_value}  expected_status=200
    ${valid_last_default}=    GET  %{HOST}/mementos/cdx  params=url=${TEST_URL}&collapseToLast=${default_value}  expected_status=200


*** Test Cases ***
             
# ---- Collapse First and Last  ----
#                    Field         Invalid           Valid             Default                      
CollapseFirstAndLast urlkey        urlkey:100        urlkey:10         urlkey
CollapseFirstAndLast mimetype      mimetype:100      mimetype:5        mimetype
CollapseFirstAndLast digest        digest:41         digest:5          digest
CollapseFirstAndLast timestamp     timestamp:15      timestamp:5       timestamp
CollapseFirstAndLast statuscode    statuscode:4      statuscode:1      statuscode
CollapseFirstAndLast length        length:13         length:10         length 
CollapseFirstAndLast offset        offset:13         offset:10         offset
CollapseFirstAndLast filename      filename:100      filename:10       filename
CollapseFirstAndLast redirecturl   redirecturl:100   redirecturl:10    redirecturl
CollapseFirstAndLast original      original:100      original:10       original
CollapseFirstAndLast robotflags    robotflags:10     robotflags:1      robotflags


