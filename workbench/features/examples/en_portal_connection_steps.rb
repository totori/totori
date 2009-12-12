# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Example: Portal connection steps (english)
#

Given /I am on the main page/ do
  @portal.goto(@config.root_url)
end

Given /I am not logged in/ do
  if @portal.logged_in?
    @portal.logoff
  end
end

Given /I am logged in/ do
  if !@portal.logged_in?
    Given("I am on the main page")
    user = @config.valid_credential
    Given("I log in with credentials #{user[:name]} and #{user[:password]}")
  end
  if !@portal.logged_in?
    raise "Authentication error"
  end
end

When /I log in with credentials (.*) and (.*)/ do |user, password|
  @portal.connect(user, password)
end

When /I log off/ do
  @portal.logoff
end

Then /I should see the (.+) message "(.+)"/ do |severity, text|
  case severity
    when "error" then @portal.reports_error?(text)
    when "warning" then @portal.reports_warning?(text)
    when "success" then @portal.reports_success?(text)
  end
end

Then /I should be logged in/ do
  @portal.logged_in?
end

Then /I should be logged off/ do
  !@portal.logged_in?
end
