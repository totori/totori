# Totori - User Acceptance Testing Workbench
# http://github.com/arnaud/totori - MIT License

#
# Screenshots module
#
module Screenshots
  def add_screenshot(description)
    id = "screenshot_#{Time.new.to_i}"
	  @browser.bring_to_front
    take_screenshot(id)
    embed("#{@config.report['screenshots']['dir']}/#{id}.png|#{description}", "image/png")
  end

  if Cucumber::OS_X
    def take_screenshot(id)
      `screencapture -t png #{@config.report['dir']}/#{@config.report['screenshots']['dir']}/#{id}.png`
    end
  elsif Cucumber::WINDOWS
    def take_screenshot(id)
      `..\\ext\\nircmd\\nircmd savescreenshotwin #{@config.report['dir']}\\#{@config.report['screenshots']['dir']}\\#{id}.png`
    end
  else
    # Other platforms...
    def take_screenshot(id)
      STDERR.puts "Sorry - no screenshots on your platform yet."
    end
  end
end

After do |scenario|
  if @config.report['screenshots']['after'] == "each scenario"
    add_screenshot(scenario.name)
  end
  if @config.report['screenshots']['after'] == "each failed scenario"
    add_screenshot(scenario.name) if scenario.failed?
  end
end

After do |step|
  if @config.report['screenshots']['after'] == "each step"
    add_screenshot("#{step.name} - line ##{step.line}")
  end
  if @config.report['screenshots']['after'] == "each failed step"
    add_screenshot("#{step.name} - line ##{step.line}") if step.failed?
  end
end

World(Screenshots)