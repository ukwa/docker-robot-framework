*** Settings ***
Documentation     Run accessibility tests on representative pages of the site.
Library           /Pa11yLibrary.py
Default Tags      a11y    website

*** Test Cases ***
Run Pa11y On Homepage
    Run Pa11y On URL    %{HOST}

Run Pa11y On Topics & Themes
    Run Pa11y On URL    %{HOST}/en/ukwa/collection
