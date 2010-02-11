# Totori - User Acceptance Testing Workbench
# http://github.com/totori/totori - MIT License

#
# Portal basic steps (english)
#

##################################################
# Logging

Given /^I am on the main page$/ do
  @portal.goto(@config.portal['root_url'])
end

Given /^I am not logged in$/ do
  if @portal.logged_in?
    @portal.logoff
  end
end

Given /^I am logged in$/ do
  if !@portal.logged_in?
    Given("I am on the main page")
    user = @config.portal['valid_credential']
    Given("I log in with credentials #{user[:login]} and #{user[:password]}")
  end
  if !@portal.logged_in?
    raise "Authentication error"
  end
end

When /^I log in with credentials (.*) and (.*)$/ do |user, password|
  @portal.connect(user, password)
end

When /^I log off/ do
  @portal.logoff
end

Then /^I should see the ([^\s]+) message "([^\"]*)"$/ do |severity, text|
  case severity
    when "error" then @portal.reports_error?(text)
    when "warning" then @portal.reports_warning?(text)
    when "success" then @portal.reports_success?(text)
  end
end

Then /^I should be logged in$/ do
  @portal.logged_in?
end

Then /^I should be logged off$/ do
  !@portal.logged_in?
end

##################################################
# Top-level navigation

When /^I click on the "([^\"]*)" main tab in the top-level navigation$/ do |tab|
  @portal.tln_main_tab(tab).click
end

When /^I click on the "([^\"]*)" sub-tab in the top-level navigation$/ do |tab|
  @portal.tln_sub_tab(tab).click
end

Then /^I should see "([^\"]*)" in the page title bar$/ do |title|
  @portal.page_title_bar.text.should == title
end

##################################################
# Forms

When /^I fill the field "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  find_textfield_by_name(field).set(value)
end

When /^I check the checkbox "([^\"]*)"$/ do |field|
  find_checkbox_by_name(field).click
end

When /^I click on the ([^\s]+) "([^\"]*)"$/ do |type, label|
  case type
  when "button"
    @portal.app.link(:text, label).click
  else
    fail("Not implemented: When I click on the #{type} \"([^\\\"]*)\"")
  end
end

When /^I click on the ([^\s]+) ([^\s]+) "([^\"]*)"$/ do |position, type, label|
  pos = times_to_i(position)
  case type
  when "button"
    @portal.app.link(:text => label, :index => pos).click
  else
    fail("Not implemented: When I click on the #{position} #{type} \"([^\\\"]*)\"")
  end
end

When /^I select "([^\"]*)" in its dropdown$/ do |value|
  #TODO
  #dropdown = @portal.last_dropdown
  pending
end

Then /^the textview "([^\"]*)" should contain "([^\"]*)"$/ do |field, value|
  find_textview_by_name(field).text.should == value
end

When /^I fill the text field with "([^\"]*)"$/ do |value|
  @portal.app.text_field(:type => 'text', :class => /ur.+TxtEnbl/).set(value)
end

##################################################
# Tables

When /^I select the (.+) row of the table "([^\"]+)"$/ do |position, table|
  t = find_table_by_id(table)
  @portal.last_table = t
  When("I select the #{position} row of this table")
end

When /^I select the (.+) row of this table$/ do |position|
  t = @portal.last_table
  pos = times_to_i(position)
  r = t[pos+1] # select the tablerow at position 'pos'
  c = r[2] # select the first cell (not the button one)
  c.click
end

When /^the table "([^\"]+)" contains exactly (.+) rows?$/ do |table, rows|
  t = find_table_by_id(table)
  @portal.last_table = t
  t.row_count_excluding_nested_tables().should == (rows.to_i + 1)
end

When /^I filter the "([^\"]+)" column with "([^\"]*)"$/ do |position, value|
  pos = times_to_i(position)
  #TODO
  #@portal.last_table...
  pending
end

##################################################
# Trays

When /^I click on the "([^\"]+)" navigation tray menu$/ do |menu|
  @portal.app.table(:class => 'urTrcWhlHdr', :text => /#{menu}/).button(:class, 'urTrcMenuIcoTrn').click
end

When /^I select "([^\"]+)" in its menu$/ do |value|
  #FIXME
  @portal.app.div(:class, 'urMnu').row(:text => /.*#{Regexp.escape(value)}.*/).click
end
