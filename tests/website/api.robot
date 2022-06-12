

*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    String

*** Test Cases ***

Check the API documentation page is there
    ${response}=    GET  %{HOST}/api  params=query=ciao  expected_status=200
    Should Contain    ${response.text}    UK Web Archive API
    Should Contain    ${response.text}    swagger.json
	
Query CDX API, no URL
    ${response}=    GET  %{HOST}/api/query/lookup  params=query=ciao  expected_status=200
    Should Contain    ${response.text}    exactly one of 'url' or 'urlkey' is required

Query CDX API, bad URL
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=notanykindofmatchhere  expected_status=200
    Should Be Equal    ${response.text}    ${EMPTY}

Query CDX API, TEST_URL
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}

Query CDX API, Invalid matchType
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&matchType=foobar  expected_status=200
    Should Contain    ${response.text}    IllegalArgumentException

Query CDX API, Valid matchType exact 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&matchType=exact  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query CDX API, Valid matchType prefix 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&matchType=prefix  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query CDX API, Valid matchType host 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&matchType=host  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query CDX API, Valid matchType domain 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&matchType=domain  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query CDX API, Valid matchType range 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&matchType=range  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query CDX API, Invalid sort
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&sort=foobar  expected_status=200
    Should Contain    ${response.text}    IllegalArgumentException

Query CDX API, Valid sort default 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&sort=default  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query CDX API, Valid sort closest 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&sort=closest  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query CDX API, Valid sort reverse 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&sort=reverse  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query CDX API, Valid combination 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&sort=reverse&matchType=exact  expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query CDX API, Invalid combination 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=%{TEST_URL}&sort=reverse&matchType=domain  expected_status=200
    Should Contain    ${response.text}    IllegalArgumentException

Query Resolve, Valid, Allow Redirects
    ${response}=    GET    %{HOST}/api/query/resolve/19900101120000/%{TEST_URL}    expected_status=307    allow_redirects=${False}
    Should Contain    ${response.text}    %{TEST_URL}

Query Resolve, Valid
    ${response}=    GET    %{HOST}/api/query/resolve/19900101120000/%{TEST_URL}    expected_status=200
    Should Contain    ${response.text}    %{TEST_URL}
	
Query Resolve, Invalid Timestamp
    ${response}=    GET    %{HOST}/api/query/resolve/foobar/%{TEST_URL}    expected_status=404
    Should Contain    ${response.text}    %{TEST_URL}
	
Query Resolve, Invalid URL
    ${response}=    GET    %{HOST}/api/query/resolve/19900101120000/foobar  expected_status=404
    Should Contain    ${response.text}    foobar
	
Query Resolve, Invalid Timestamp, Allow Redirects
    ${response}=    GET    %{HOST}/api/query/resolve/foobar/%{TEST_URL}    expected_status=307    allow_redirects=${False}
    Should Contain    ${response.text}    %{TEST_URL}
	
Query Resolve, Invalid URL, Allow Redirects
    ${response}=    GET    %{HOST}/api/query/resolve/19900101120000/foobar  expected_status=307    allow_redirects=${False}
    Should Contain    ${response.text}    foobar
	
Query WARC, Invalid Timestamp
    Skip  # 500 status, possible untrapped error
    ${response}=    GET    %{HOST}/api/query/warc/foobar/%{TEST_URL}    expected_status=404
    Should Contain    ${response.text}    %{TEST_URL}
	
Query WARC, Invalid URL
    ${response}=    GET    %{HOST}/api/query/warc/19900101120000/foobar  expected_status=404
    Should Contain    ${response.text}    The requested URL was not found on the server
		
Query WARC, Valid
    ${response}=    GET    %{HOST}/api/query/warc/19900101120000/%{TEST_URL}    expected_status=200
    Should Contain    ${response.text}    WARC-Target-URI: %{TEST_URL}
    Should Contain    ${response.text}    %{TEST_URL}

Query IIIF Helper
    ${response}=    GET    %{HOST}/api/iiif/helper/20130415044640/%{TEST_URL}   expected_status=303    allow_redirects=${False}
    Should Contain    ${response.text}    urn:pwid:webarchive
	
Query IIIF Helper, Redirect
    ${response}=    GET    %{HOST}/api/iiif/helper/20130415044640/%{TEST_URL}     expected_status=200
	Set Global Variable    ${new_url}    ${response.url} 	
	${matches}=      Get Regexp Matches       ${new_url}      :\\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\dZ:
    Set Global Variable         ${timestamp}         ${matches[0]}
	
Query IIIF Helper, Invalid URL
    ${response}=    GET    %{HOST}/api/iiif/helper/20130415044640/foobar   expected_status=404
    Should Contain    ${response.text}    Not Found
	
#TODO: Authentication issue on Dev only; presumably similar to the issue requiring HOST/HOST_NO_AUTH split
Query IIIF Image From Helper
    ${response}=    GET    ${new_url}    expected_status=200
    
Quesry IIF Info From Helper
    ${response}=    GET    %{HOST}/api/iiif/2/urn:pwid:webarchive.org.uk${timestamp}page:%{TEST_URL}/info.json
    Should Contain    ${response.text}    iiif.io/api/image/2/context.json	
	
Query IIF Info, Invalid URL
    ${response}=    GET    %{HOST}/api/iiif/2/foobar    expected_status=404
    Should Contain    ${response.text}    The requested URL was not found on the server
	
Quesry Stats
    ${response}=    GET    %{HOST}/api/stats/crawl/recent-activity
    Should Contain    ${response.text}    hosts
	Should Contain    ${response.text}    stats
	Should Contain    ${response.text}    first_timestamp	







