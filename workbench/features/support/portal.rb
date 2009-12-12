# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# SAP Enterprise Portal class
#
class Portal
  
  # Initialize the portal (constructor)
  def initialize(browser)
    @browser = browser
  end
  
  # Navigate to a specific URL
  def goto(url)
    @browser.goto(url)
  end
  
  # Test wether we're logged in or not
  def logged_in?
    #begin
    #  assert @browser.cell(:id, 'welcome_message').text.contains?("Welcome")
    #rescue
    #  false
    #end
    @browser.contains_text("Log Off") #TODO should be enhanced
  end
  
  # Connect to the portal using credentials
  def connect(user, password)
    @browser.text_field(:id, 'logonuidfield').set(user)
    @browser.text_field(:id, 'logonpassfield').set(password)
    @browser.button(:name, 'uidPasswordLogon').click
  end
  
  # Log off the portal
  def logoff
    begin
      @browser.form(:name, 'logoffForm').submit
    rescue
      raise "Can't log off: not logged in yet!"
    end
  end
  
  # Test if the "message" error is displayed
  def reports_error?(message)
    reports_message?('urMsgBarErr', message)
  end
  
  # Test if the "message" warning is displayed
  def reports_warning?(message)
    reports_message?('urMsgBarWarn', message) #TODO check
  end
  
  # Test if the "message" success is displayed
  def reports_success?(message)
    reports_message?('urMsgBarSucc', message) #TODO check
  end

private
  # Test if the "message" is displayed, the severity being one of the following:
  # * error
  # * warning
  # * success
  def reports_message?(severity, message)
    # TODO check it works properly
    @browser.cell(:xpath, "//div[@class='#{severity}']").text.should == message
    #divs = @browser.divs
    #divs.each do |d|
    #  if d.text.match( /#{message}/i )
    #    if d.class_name.match(/#{severity}/i)
    #      return true
    #    end
    #  end
    #end
    #false
  end
end
