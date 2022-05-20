*** Settings ***
Documentation     Run accessibility tests on representative pages of the site.
Library           /Pa11yLibrary.py
Default Tags      a11y    website
Test Template     Run Pa11y On URL

*** Test Cases ***                  URL


# ----- UKWA ----- #

# english 
EN Home                             %{HOST}/en/ukwa/index
EN Topics and Themes                %{HOST}/en/ukwa/category
EN Save a UK website                %{HOST}/en/ukwa/nominate
EN Contact Us                       %{HOST}/en/ukwa/contact
EN About Us                         %{HOST}/en/ukwa/about
EN British Stand-up Comedy          %{HOST}/en/ukwa/collection/329
EN French in London                 %{HOST}/en/ukwa/collection/309
EN News Sites                       %{HOST}/en/ukwa/collection/138
EN Accessibility Statement          %{HOST}/en/ukwa/info/accessibility_statement
EN Notice and Takedown              %{HOST}/en/ukwa/info/notice_takedown
EN Terms and Conditions             %{HOST}/en/ukwa/info/terms_conditions
EN Cookie Policy                    %{HOST}/en/ukwa/info/cookies
EN FAQ                              %{HOST}/en/ukwa/info/faq
EN Technical information            %{HOST}/en/ukwa/info/technical
EN Reading Room Only                %{HOST}/en/ukwa/noresults
EN Error Page                       %{HOST}/en/foobar
EN Search Page                      %{HOST}/en/ukwa/search?text=test&search_location=full_text

# welsh
CY Home                             %{HOST}/cy/ukwa/index
CY Topics and Themes                %{HOST}/cy/ukwa/category
CY Save a UK website                %{HOST}/cy/ukwa/nominate
CY Contact Us                       %{HOST}/cy/ukwa/contact
CY About Us                         %{HOST}/cy/ukwa/about
CY British Stand-up Comedy          %{HOST}/cy/ukwa/collection/329
CY French in London                 %{HOST}/cy/ukwa/collection/309
CY News Sites                       %{HOST}/cy/ukwa/collection/138
CY Accessibility Statement          %{HOST}/cy/ukwa/info/accessibility_statement
CY Notice and Takedown              %{HOST}/cy/ukwa/info/notice_takedown
CY Terms and Conditions             %{HOST}/cy/ukwa/info/terms_conditions
CY Cookie Policy                    %{HOST}/cy/ukwa/info/cookies
CY FAQ                              %{HOST}/cy/ukwa/info/faq
CY Technical information            %{HOST}/cy/ukwa/info/technical
CY Reading Room Only                %{HOST}/cy/ukwa/noresults
CY Error Page                       %{HOST}/cy/foobar
CY Search Page                      %{HOST}/cy/ukwa/search?text=test&search_location=full_text


# gaelic
GD Home                             %{HOST}/gd/ukwa/index
GD Topics and Themes                %{HOST}/gd/ukwa/category
GD Save a UK website                %{HOST}/gd/ukwa/nominate
GD Contact Us                       %{HOST}/gd/ukwa/contact
GD About Us                         %{HOST}/gd/ukwa/about
GD British Stand-up Comedy          %{HOST}/gd/ukwa/collection/329
GD French in London                 %{HOST}/gd/ukwa/collection/309
GD News Sites                       %{HOST}/gd/ukwa/collection/138
GD Accessibility Statement          %{HOST}/gd/ukwa/info/accessibility_statement
GD Notice and Takedown              %{HOST}/gd/ukwa/info/notice_takedown
GD Terms and Conditions             %{HOST}/gd/ukwa/info/terms_conditions
GD Cookie Policy                    %{HOST}/gd/ukwa/info/cookies
GD FAQ                              %{HOST}/gd/ukwa/info/faq
GD Technical information            %{HOST}/gd/ukwa/info/technical
GD Reading Room Only                %{HOST}/gd/ukwa/noresults
GD Error Page                       %{HOST}/gd/foobar
GD Search Page                      %{HOST}/gd/ukwa/search?text=test&search_location=full_text


# ----- Wayback ----- #

# english 
EN Home                             %{HOST}/wayback/en/
EN Calendar                         %{HOST}/wayback/en/archive/*/http://www.chortle.co.uk/comics/m/25/mark_thomas
EN Archive                          %{HOST}/wayback/en/archive/
EN Archive Error                    %{HOST}/wayback/en/archive/http://foobar/
EN Wayback Error                    %{HOST}/wayback/en/foobar/

# welsh
CY Home                             %{HOST}/wayback/cy/
CY Calendar                         %{HOST}/wayback/cy/archive/*/http://www.chortle.co.uk/comics/m/25/mark_thomas
CY Archive                          %{HOST}/wayback/cy/archive/
CY Archive Error                    %{HOST}/wayback/en/archive/http://foobar/
CY Wayback Error                    %{HOST}/wayback/cy/foobar/
