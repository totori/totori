# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Environement
#

# for windows console
require 'cucumber/formatter/unicode'
# rspec
require 'spec/expectations'
# for reading config.yml
require 'ostruct'
require 'yaml'

## CONFIG

config = YAML.load_file("config/myconfig.yml") || {}
config = config['config'] || {}
config = OpenStruct.new(config)

Before do
  @config = config
end


## WATIR

case config.watir['browser']
when /(ie)|(IE)/
  require 'watir'
  Browser = Watir::IE
when /(f|F)irefox/
  require 'firewatir'
  Browser = FireWatir::Firefox
when /(c|C)hrome/
  require 'chrome_watir'
  Browser = ChromeWatir::Browser
when /(s|S)afari/
  require 'safariwatir'
  Browser = Watir::Safari
when /(c|C)elerity/
  require 'celerity'
  Browser = Celerity::Browser
else
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
end

# "before all"
browser = Browser.new
case config.watir['speed']
when /fast/
  browser.speed = :fast
when /slow/
  browser.speed = :slow
end
browser.maximize if config.watir['maximize']
browser.bring_to_front if config.watir['bring_to_front']

Before do
  @browser = browser
  @portal = Portal.new(@browser)
end

# "after all"
at_exit do
  browser.close unless browser.nil?
end
