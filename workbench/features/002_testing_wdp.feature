# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

Feature: Testing a custom Web DynPro application
  In order to calculate my age
  As a user
  I want to use the age calculation application
  
  Background:
    Given I am on the main page
    And I am not logged in
    And I log in with credentials testuser01 and abcd1234
    And I click on the "Testing Web Dynpro" main tab in the top-level navigation
    And I click on the "Age calculator" sub-tab in the top-level navigation
  
  Scenario: Check if the application is running
    Then I should see "Age calculator" in the page title bar
  
  Scenario Outline: Use the application with film directors and time travelers
    When I fill the field "First name" with "<first name>"
    And I fill the field "Last name" with "<last name>"
    And I fill the field "Birthday" with "<birthday>"
    And I click on the button "Calculate age"
    Then the textview "Age" should contain "<expected age>"
    And I should see the <message type> message "<message text>"
    
    Examples:
      | first name | last name | birthday   | expected age | message type | message text                          |
      | Steven     | Spielberg | 12/18/1946 | 63 years old | success      | Your age was calculated successfully. |
      | Stanley    | Kubrick   | 07/26/1928 | 81 years old | success      | Your age was calculated successfully. |
      | Martin     | Scorsese  | 11/17/1942 | 67 years old | success      | Your age was calculated successfully. |
      | James      | Cameron   | 08/19/1954 | 55 years old | success      | Your age was calculated successfully. |
      | David      | Psilvburg | 05/13/2438 |              | error        | Did you time travel?!                 |
      | Duncan     | MacLeod   | 01/19/6102 |              | error        | Did you time travel?!                 |
