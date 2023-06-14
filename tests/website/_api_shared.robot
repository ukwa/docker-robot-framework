*** Settings ***
Documentation     A resource file with reusable keywords and variables.
Library           RequestsLibrary
Library           Collections
Library           String



*** Variables ***
#reading room only/restricted access
${RRO_URL}                  %{TEST_RRO_URL=http://bbc.co.uk}
${TEST_URL}                 %{TEST_URL=http://portico.bl.uk}
${TEST_TIMESTAMP}           %{TEST_TIMESTAMP=19950418155600}
${TEST_FULL_TIMESTAMP}      %{TEST_FULL_TIMESTAMP=1995-04-18T15:56:00Z}
${TEST_APPROX_TIMESTAMP}    %{TEST_TIMESTAMP=19950101000000}
${TEST_VALID_COLLECTIONID}    %{TEST_VALID_COLLECTIONID=4388}
${TEST_INVALID_COLLECTIONID}    %{TEST_INVALID_COLLECTIONID=999999}



