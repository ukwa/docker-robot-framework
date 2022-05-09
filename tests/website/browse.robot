*** Settings ***
Documentation     Verify basic browse functionality of the UKWA website.
Resource          _resource.robot

# Set up a browser context for this whole sequence of tests:
Suite Setup     Setup Browser


*** Test Cases ***
Open Homepage
    [Tags]  homepage
    New Page    %{HOST}
    Page Should Contain    What we do

Browse View Collections
    [Tags]   browse 
    Go To    %{HOST}/ukwa/collection
    Page Should Contain    Topics
	
Browse View A Collection
    [Tags]   browse
    Go To    %{HOST}/ukwa/collection/44
    Page Should Contain    Blogs

Browse EN View Collections
    [Tags]   browse    locale    en
    Go To    %{HOST}/en/ukwa/collection
    Page Should Contain    Topics

Browse EN View A Collection
    [Tags]   browse    locale    en
    Go To    %{HOST}/en/ukwa/collection/44
    Page Should Contain    Blogs

Browse CY View Collections
    [Tags]   browse    locale    cy
    Go To    %{HOST}/cy/ukwa/collection
    Page Should Contain    Pynciau

Browse CY View A Collection
    [Tags]   browse    locale    cy
    Go To    %{HOST}/cy/ukwa/collection/44
    Page Should Contain    Blogs

