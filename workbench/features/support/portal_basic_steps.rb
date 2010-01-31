# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Portal basic steps (english)
#

#

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
    Given("I log in with credentials #{user[:name]} and #{user[:password]}")
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

When /^I click on the button "([^\"]*)"$/ do |button|
  @portal.app.link(:text, button).click
end

When /^I check the checkbox "([^\"]*)"$/ do |field|
  find_checkbox_by_name(field).click
end

Then /^the field "([^\"]*)" should contain "([^\"]*)"$/ do |field, value|
  find_cell_by_name(field).text.should == value
end

Then /^the textview "([^\"]*)" should contain "([^\"]*)"$/ do |field, value|
  find_textview_by_name(field).text.should == value
end

##################################################
# Helpers

def find_cell_by_name(name)
  @portal.app.cell(:id, find_cell_id_by_label_name(name))
end

def find_textfield_by_name(name)
  @portal.app.text_field(:id, find_cell_id_by_label_name(name))
end

def find_checkbox_by_name(name)
  @portal.app.checkbox(:id, find_cell_id_by_label_name(name))
end

def find_textview_by_name(name)
  @portal.app.span(:id, find_cell_id_by_label_name(name))
end

private

def find_cell_id_by_label_name(name)
  label_regexp = Regexp.new(name + "\s?\:?")
  l = @portal.app.label(:text, label_regexp)
  id = l.attribute_value('f')
  id
end
