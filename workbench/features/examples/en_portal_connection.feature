# language: en

# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Example: Portal connection feature (english)
#

@example @en
Feature: Portal logging in and logging off
  In order to check access the portal
  As a user
  I want to log into the portal and log off
  
  @example
  Scenario Outline: Unauthorized credentials
    Given I am on the main page
    And I am not logged in
    When I log in with credentials <user> and <password>
    Then I should see the error message "Echec de l'authentification de l'utilisateur"
    
    Examples:
      | user           | password |
      | unknown_user_1 | toto     |
      | unknown_user_2 | toto     |
      | unknown_user_3 | toto     |
  
  @example
  Scenario Outline: Authorized credentials
    Given I am on the main page
    And I am not logged in
    When I log in with credentials <user> and <password>
    Then I should be logged in
    
    Examples:
      | user           | password |
      | user_01        | abcd1234 |
  
  @example
  Scenario: Logging off
    Given I am logged in
    When I log off
    Then I should be logged off
