
*** Settings ***
Library    Collections
Library    RequestsLibrary

*** Test Cases ***
Check the API documentation page is there
    ${response}=    GET  %{HOST}/api  params=query=ciao  expected_status=200
    Should Contain    ${response.text}    UK Web Archive API
    Should Contain    ${response.text}    swagger.json

# ---

Query CDX API, no URL
    ${response}=    GET  %{HOST}/api/query/lookup  params=query=ciao  expected_status=200
    Should Contain    ${response.text}    exactly one of 'url' or 'urlkey' is required

Query CDX API, bad URL
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=notanykindofmatchhere  expected_status=200
    Should Be Equal    ${response.text}    ${EMPTY}

Query CDX API, TEST_URL
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}

# ---

Query Resolve API, TEST_URL
    ${response}=    GET    %{HOST}/api/query/resolve/19900101120000/%{TEST_URL}    expected_status=307    allow_redirects=${False}
    ${response}=    GET    %{HOST}/api/query/resolve/19900101120000/%{TEST_URL}    expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}

# ---
# 19950418155600/http://portico.bl.uk/

Query WARC API, TEST_URL
    ${response}=    GET    %{HOST}/api/query/warc/19900101120000/%{TEST_URL}    expected_status=200
    Should Contain    ${response.text}    WARC-Target-URI: %{TEST_URL}
    Should Contain    ${response.text}    %{TEST_URL}
