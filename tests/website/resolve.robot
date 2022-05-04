*** Settings ***
Documentation     Verify URL resolution functionality required by e.g. Document Harvester
Resource          _resource.robot
Suite Setup     Setup Browser


*** Test Cases ***
Get to Archived Web Page via the Resolve API
    [Tags]   resolve
    Go To    %{HOST}/access/resolve/19950418155600/http://portico.bl.uk
    Page Should Contain    Portico

