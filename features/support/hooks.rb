# features/support/hooks.rb
Before do
  $driver.start_driver
end

After do |scenario|
  puts "Finalizando um cenário"
  if scenario.failed?
    begin
      failed_scenario = scenario.location.file + ':' + scenario.location.line.to_s + "\n"
      File.write(filename, failed_scenario, mode: 'a') unless File.file?(filename) && File.new(filename, 'r').read.include?(failed_scenario)
    rescue StandardError
      # ignored
    end
    dir = "#{ENV['PWD']}/screenshots/#{ENV['PLATFORM']}"
    file = "#{dir}/#{Time.now.strftime('%Y_%m_%d_%Y_%H_%M_%S')}.png"
    begin
      i ||= 1
      screenshot(file)
      wait(40) { embed file, 'image/png', 'screenshot - ' + ENV['PLATFORM'] }
    rescue Appium::Core::Wait::TimeoutError, NoMethodError, Selenium::WebDriver::Error::UnknownError
      i -= 1
      retry if i.zero?
    end
  end

  begin
    close_app
  rescue StandardError
    # ignored
  end

  ReleaseHubNode.node_session session_id unless ENV['HUB'].nil?
  begin
    driver_quit
  rescue StandardError => e
    puts e.to_s
  end
end
