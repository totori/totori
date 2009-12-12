# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

require 'cucumber/formatter/unicode'
#require 'spec/expectations'

## CONFIG

require 'config/myconfig'
config = MyConfig.new

Before do
  @config = config
end


## WATIR

if ENV['FIREWATIR']
  require 'firewatir'
  Browser = FireWatir::Firefox
else
  case RUBY_PLATFORM
  when /darwin/
    require 'safariwatir'
    Browser = Watir::Safari
  when /win32|mingw/
    require 'watir'
    Browser = Watir::IE
  when /java/
    require 'celerity'
    Browser = Celerity::Browser
  else
    raise "This platform is not supported (#{PLATFORM})"
  end
end

# "before all"
browser = Browser.new
browser.speed = :fast
browser.maximize
browser.bring_to_front

Before do
  @browser = browser
  @portal = Portal.new(@browser)
end

# "after all"
at_exit do
  browser.close unless browser.nil?
end
