# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Screenshots module
#
module Screenshots
  def add_screenshot
    id = "screenshot_#{Time.new.to_i}"
	@browser.bring_to_front
    take_screenshot(id)
    embed("screens/#{id}.png", "image/png")
  end

  if Cucumber::OS_X
    def take_screenshot(id)
      `screencapture -t png reports/screens/#{id}.png`
    end
  elsif Cucumber::WINDOWS
	def take_screenshot(id)
	  `mkdir reports 2> nul`
	  `mkdir reports\\screens 2> nul`
	  `..\\ext\\nircmd\\nircmd savescreenshotwin reports\\screens\\#{id}.png`
	end
  else
    # Other platforms...
    def take_screenshot(id)
      STDERR.puts "Sorry - no screenshots on your platform yet."
    end
  end
end

#After(@screenshot) do
#  add_screenshot
#end

After do |scenario|
  add_screenshot if scenario.failed?
end

World(Screenshots)