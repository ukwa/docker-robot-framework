


*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    String


*** Variables ***
#reading room only/restricted access
${RRO_URL}                  %{TEST_RRO_URL=http://bbc.co.uk}
${TEST_URL}                 %{TEST_URL=http://portico.bl.uk}
${TEST_TIMESTAMP}           %{TEST_TIMESTAMP=19950418155600}
${TEST_FULL_TIMESTAMP}      %{TEST_FULL_TIMESTAMP=1995-04-18T15:56:00Z}
${TEST_APPROX_TIMESTAMP}    %{TEST_TIMESTAMP=19950101000000}

*** Keywords ***

Generate PWID    [Arguments]    ${timestamp}    ${url} 	 	 
    ${url_quoth}=     Evaluate   urllib.parse.quote_plus('${url}')
    ${pwid}=          Evaluate   'urn:pwid:webarchive.org.uk:${timestamp}:page:${url_quoth}'
    [Return]          ${pwid}


*** Test Cases ***

Check the API documentation page is there
    ${response}=    GET  %{HOST}/api    expected_status=200
    Should Contain    ${response.text}    UK Web Archive API
    Should Contain    ${response.text}    swagger-ui
	
# ---------------------------
# Mementos - CDX query
# ---------------------------

Query CDX API, no URL
    ${response}=    GET  %{HOST}/api/query/lookup  params=query=ciao  expected_status=422
    Should Contain    ${response.text}    field required

Query CDX API, bad URL
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=notanykindofmatchhere  expected_status=422
    Should Contain    ${response.text}    invalid or missing URL scheme

Query CDX API, valid URL, no hits
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=http://no.such.url  expected_status=200
    Should Be Equal    ${response.text}    ${EMPTY}

Query CDX API, TEST_URL
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}

Query CDX API, Invalid matchType
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&matchType=foobar  expected_status=422
    Should Contain    ${response.text}    value is not a valid enumeration member

Query CDX API, Valid matchType exact 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&matchType=exact  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query CDX API, Valid matchType prefix 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&matchType=prefix&limit=10  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query CDX API, Valid matchType host 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&matchType=host&limit=10  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query CDX API, Valid matchType domain 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&matchType=domain&limit=10  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query CDX API, Valid matchType range 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&matchType=range&limit=10  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query CDX API, Invalid sort
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&sort=foobar  expected_status=422
    Should Contain    ${response.text}    value is not a valid enumeration member

Query CDX API, Valid sort default 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&sort=default  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query CDX API, Valid sort closest 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&sort=closest  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query CDX API, Valid sort reverse 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&sort=reverse  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query CDX API, Valid combination 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&sort=reverse&matchType=exact  expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query CDX API, Invalid combination 
    ${response}=    GET  %{HOST}/api/query/lookup  params=url=${TEST_URL}&sort=reverse&matchType=domain  expected_status=200
    Should Contain    ${response.text}    IllegalArgumentException

# ---------------------------
# Mementos - Resolve
# ---------------------------

Query Resolve, Valid, No Redirects
    ${response}=    GET    %{HOST}/api/mementos/resolve/${TEST_TIMESTAMP}/${TEST_URL}    expected_status=303    allow_redirects=${False}
    Should Be Equal    ${response.text}    ${EMPTY}

Query Resolve, Valid
    ${response}=    GET    %{HOST}/api/query/resolve/${TEST_TIMESTAMP}/${TEST_URL}    expected_status=200
    Should Contain    ${response.text}    ${TEST_URL}
	
Query Resolve, Invalid Timestamp
    ${response}=    GET    %{HOST}/api/query/resolve/foobar/${TEST_URL}    expected_status=422
    Should Contain    ${response.text}    ensure this value has at least 14 characters
	
Query Resolve, Invalid URL
    ${response}=    GET    %{HOST}/api/query/resolve/${TEST_TIMESTAMP}/foobar  expected_status=422
    Should Contain    ${response.text}    invalid or missing URL scheme
	
Query Resolve, Valid URL, No Matches
    ${response}=    GET    %{HOST}/api/query/resolve/${TEST_TIMESTAMP}/https://no.such.url  expected_status=404
    Should Contain    ${response.text}    Not Found
	
Query Resolve, Invalid Timestamp, No Redirects
    ${response}=    GET    %{HOST}/api/mementos/resolve/foobar/${TEST_URL}    expected_status=422    allow_redirects=${False}
    Should Contain    ${response.text}    ensure this value has at least 14 characters
	
Query Resolve, Invalid URL, No Redirects
    ${response}=    GET    %{HOST}/api/mementos/resolve/${TEST_TIMESTAMP}/foobar  expected_status=422    allow_redirects=${False}
    Should Contain    ${response.text}    invalid or missing URL scheme
	
# ---------------------------
# Mementos - WARC
# ---------------------------

Query WARC, Invalid Timestamp
    ${response}=    GET    %{HOST}/api/query/warc/foobar/${TEST_URL}    expected_status=422
    Should Contain    ${response.text}    ensure this value has at least 14 characters
	
Query WARC, Invalid URL
    ${response}=    GET    %{HOST}/api/query/warc/${TEST_TIMESTAMP}/foobar  expected_status=422
    Should Contain    ${response.text}    invalid or missing URL scheme
		
Query WARC, Valid URL, No Records
    ${response}=    GET    %{HOST}/api/query/warc/${TEST_TIMESTAMP}/http://no.such.url  expected_status=404
    Should Contain    ${response.text}    Not Found
		
Query WARC, Valid URL, Timestamp Mismatch
    ${response}=    GET    %{HOST}/api/mementos/warc/${TEST_APPROX_TIMESTAMP}/${TEST_URL}    expected_status=303    allow_redirects=${False}
    Should Be Equal    ${response.text}    ${EMPTY}
    Should Contain    ${response.headers['location']}    ${TEST_TIMESTAMP}

Query WARC, Valid
    ${response}=    GET    %{HOST}/api/query/warc/${TEST_TIMESTAMP}/${TEST_URL}    expected_status=200
    Should Contain    ${response.text}    WARC-Target-URI: ${TEST_URL}
    Should Contain    ${response.text}    ${TEST_URL}

# ---------------------------
# Mementos - Screenshots
# ---------------------------

Query IIIF Helper, No Redirects
    ${response}=    GET    %{HOST}/api/mementos/screenshot/${TEST_TIMESTAMP}/${TEST_URL}   expected_status=303    allow_redirects=${False}
    Should Contain    ${response.headers['location']}    /iiif/2/
    Should Contain    ${response.headers['location']}    default.png
    Should Be Equal    ${response.text}    ${EMPTY}
	
Query IIIF Helper, Allow Redirect To Image
    ${response}=    GET    %{HOST}/api/iiif/helper/${TEST_TIMESTAMP}/${TEST_URL}     expected_status=200
    Should Be Equal    ${response.headers['content-type']}    image/png
    Should Contain     ${response.content[1:4].decode('utf-8')}   PNG
    
# ---------------------------
# IIIF - Helper
# ---------------------------

Query IIIF Helper, Invalid URL
    ${response}=    GET    %{HOST}/api/iiif/helper/${TEST_TIMESTAMP}/foobar   expected_status=422
    Should Contain    ${response.text}    invalid or missing URL scheme
	
Query IIIF Helper, URL with no records
    ${response}=    GET    %{HOST}/api/iiif/helper/${TEST_TIMESTAMP}/http://no.such.url   expected_status=404
    Should Contain    ${response.text}    Not Found

# Reading-room-only test cases:

Query IIIF Helper, Reading Room Only
    ${response}=    GET    %{HOST}/api/iiif/helper/${TEST_TIMESTAMP}/${RRO_URL}    expected_status=451
	Should Contain    ${response.text}    Unavailable For Legal Reasons
	
# ---------------------------
# IIIF - Info
# ---------------------------

Query IIIF Info, Valid PWID But Invalid URL
    ${pwid}=        Generate PWID    ${TEST_FULL_TIMESTAMP}    foobar
    ${response}=    GET    %{HOST}/api/iiif/2/${pwid}/0,0,1280,1024/200,125/0/default.png    expected_status=404
    Should Contain    ${response.text}    Not Found

Query IIIF Info, PWID with no records
    ${pwid}=        Generate PWID    ${TEST_FULL_TIMESTAMP}    http://no.such.url
    ${response}=    GET    %{HOST}/api/iiif/2/${pwid}/0,0,1280,1024/200,125/0/default.png    expected_status=404
    Should Contain    ${response.text}    Not Found

Query IIIF Info, Valid URL
    ${response}=    GET    %{HOST}/api/iiif/2/urn:pwid:webarchive.org.uk:${TEST_FULL_TIMESTAMP}:page:${TEST_URL}/info.json
    Should Contain    ${response.text}    iiif.io/api/image/2/context.json	

# Reading-room-only test cases:

Query IIIF Info, Reading Room Only
    ${response}=    GET    %{HOST}/api/iiif/2/urn:pwid:webarchive.org.uk:${TEST_FULL_TIMESTAMP}:page:${RRO_URL}/info.json    expected_status=451
	Should Contain    ${response.text}    Unavailable For Legal Reasons


# ---------------------------
# IIIF - Image
# ---------------------------

Query IIIF Image
    ${pwid}=        Generate PWID    ${TEST_FULL_TIMESTAMP}    ${TEST_URL}
    ${response}=    GET    %{HOST}/api/iiif/2/${pwid}/0,0,1280,1024/200,125/0/default.png    expected_status=200
	
# Reading-room-only test cases:

Query IIIF Image, Reading Room Only
    ${pwid}=        Generate PWID    ${TEST_FULL_TIMESTAMP}    ${RRO_URL}
    ${response}=    GET    %{HOST}/api/iiif/2/${pwid}/0,0,1280,1024/200,125/0/default.png    expected_status=451
    Should Contain    ${response.text}    Unavailable For Legal Reasons

# ---------------------------
# STATS
# ---------------------------

Query Stats
    ${response}=    GET    %{HOST}/api/stats/crawl/recent-activity
    Should Contain    ${response.text}    hosts
    Should Contain    ${response.text}    stats
    Should Contain    ${response.text}    first_timestamp	
    Should Not Contain    ${response.text}    last_timestamp":"null	
	
	