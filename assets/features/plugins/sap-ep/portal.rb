# Totori - User Acceptance Testing Workbench
# http://github.com/arnaud/totori - MIT License

#
# SAP Enterprise Portal class
#
class Portal
  
  # Initialize the portal (constructor)
  def initialize(browser)
    @browser = browser
  end
  
  ##################################################
  # Navigation
  
  # Navigate to a specific URL
  def goto(url)
    @browser.goto(url)
  end
  
  ##################################################
  # Attributes
  
  # Table that was accessed for the last time
  attr_accessor :last_table
  
  # Dropdown that was accessed for the last time
  attr_accessor :last_dropdown
  
  ##################################################
  # Logging
  
  # Test wether we're logged in or not
  def logged_in?
    #begin
    #  assert @browser.cell(:id, 'welcome_message').text.contains?("Welcome")
    #rescue
    #  false
    #end
    #@browser.contains_text("Log Off")
    @browser.cell(:id, 'welcome_message').exists?
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
  
  ##################################################
  # Portal parts / @see <http://help.sap.com/saphelp_nw70/helpdata/en/02/c7918e9fca44519701c47028a053fd/content.htm>
  
  # Access the masthead
  def masthead
    nil #TODO
  end
  
  # Access the tools area
  def tools_area
    nil #TODO
  end
  
  # Access the top level navigation
  def tln
    @browser.div(:id, 'TLNDiv')
  end
  
  # Access the main tab by its name
  def tln_main_tab(name)
    tln.div(:id, 'Level1DIV').link(:text, name)
  end
  
  # Access the sub-tab by its name
  def tln_sub_tab(name)
    tln.div(:id, 'Level2DIV').link(:text, name)
  end
  
  # Access the page title bar
  def page_title_bar
    @browser.span(:xpath, "//table[@id='pageTitleBar']//span[@id='BreadCrumbDiv']")
  end
  
  # Access the desktop innerpage
  def current_page
    @browser.frame(:name, /Desktop Innerpage\s*/)
  end
  
  # Access the content area
  def content_area
    current_page.frame(:name, /isolatedWorkArea/)
  end
  
  # Access the current application
  def app
    content_area.div(:id, "_SSR_ROOT")
  end
  
  ##################################################
  # Helpers
  
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
    #FIXME
    # first, let's check directly in the current application iView
    e = app.div(:class, severity)
    if e.exists? then
      e.text.should == message
    else
      # then, in the framework page
      e = @browser.div(:class, severity)
      e.text.should == message
    end
  end
end
