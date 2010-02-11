# Totori - User Acceptance Testing Workbench
# http://github.com/totori/totori - MIT License

@example
Feature: Portal User Administration
  In order to manage users
  As an admin
  I want to add/edit/delete users and their privileges
  
  @example
  Background:
    Given I am on the main page
    And I am not logged in
    And I log in with credentials administrator and abcd1234
    And I click on the "User Administration" main tab in the top-level navigation
    #And I click on the "Identity Management" sub-tab in the top-level navigation
  
  @example
  Scenario: Check if the application is running
    Then I should see "Identity Management" in the page title bar
  
  @example
  Scenario Outline: Create a new user
    When I click on the button "Create User"
    And I fill the field "Logon ID" with "<user>"
    And I fill the field "Define Password" with "<password>"
    And I fill the field "Confirm Password" with "<password>"
    And I fill the field "Last Name" with "<last name>"
    And I fill the field "First Name" with "<first name>"
    #And I click on the dropdown "Language"
    #And I filter the first column with "en"
    #And I select the first row
    And I click on the button "Save"
    Then I should see the <message type> message "<message text>"
    
    Examples:
      | user   | password | first name | last name | language   | message type | message text |
      | test01 | init1234 | Steven     | Spielberg | en         | success      | User created |
      | test02 | init1234 | Stanley    | Kubrick   | en         | success      | User created |
  
  @example
  Scenario Outline: Delete an existing user
    When I click on the "Search" navigation tray menu
    And I select "Show All" in its menu
    And I fill the text field with "<user>"
    And I click on the button "Go"
    #And the table "userResultTable" contains exactly 1 row
    #And the table "userResultTable" contains "<user>" in the column "Logon ID"
    #And I select the first row of this table
    And I select the first row of the table "userResultTable"
    And I click on the button "Delete"
    And I click on the second button "Delete"
    Then I should see the <message type> message "<message text>"
    
    Examples:
      | user   | message type | message text                                     |
      | test01 | success      | The selected user has been deleted or cleaned up |
      | test02 | success      | The selected user has been deleted or cleaned up |
