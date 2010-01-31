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
  
  # Access the page title bar
  def page_title_bar
    e = @browser.span(:xpath, "//table[@id='pageTitleBar']//span[@id='BreadCrumbDiv']")
    e
  end
  
  # Access the current page
  def current_page
    e = @browser.frame(:name, /Desktop Innerpage\s*/)
    e
  end
  
  # Access the content area
  def content_area
    e = current_page.frame(:name, /isolatedWorkArea/)
    e
  end
  
  # Access the current application
  def app
    e = content_area.div(:id, "_SSR_CONTENT_CONTAINER")
    e
  end
  
  # Access the main tab by its name
  def tln_main_tab(name)
    @browser.link(:xpath, "//div[@id='TLNDiv']/div[@id='Level1DIV']//a[text()='"+name+"']")
  end
  
  # Access the sub-tab by its name
  def tln_sub_tab(name)
    @browser.link(:xpath, "//div[@id='TLNDiv']/div[@id='Level2DIV']//a[text()='"+name+"']")
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
    reports_message?('urMsgBarStd', message) #TODO check
  end

private
  # Test if the "message" is displayed, the severity being one of the following:
  # * error
  # * warning
  # * success
  def reports_message?(severity, message)
    app.div(:class, severity).text.should == message
  end
end
