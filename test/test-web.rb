require 'watir-webdriver'
require 'sinatra/base'
require 'thread'


#   If the web build of BoscaCeoil.swf works correctly, then it
# should call the window.Bosca._isReady() javascript function.
# In our mock test-web.html file, that function will insert a
# success message in the webpage.
#
#   This script runs a webserver, opens test-web.html in a web
# browser, and checks for the success message.


class TestApp < Sinatra::Base
  set :public_folder, File.join(File.dirname(__FILE__), '..')
end


# http://stackoverflow.com/a/16543644/1924875
def sinatra_run_wait(app, opts)
  queue = Queue.new
  thread = Thread.new do
    Thread.abort_on_exception = true
    app.run!(opts) do |server|
      queue.push("started")
    end
  end
  queue.pop # blocks until the run! callback runs
end


sinatra_run_wait(TestApp, :port => 3000, :server => 'webrick')
sleep 1

test_url = "http://localhost:3000/test/test-web.html"

client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 180 # seconds - default is 60

if Gem.win_platform?
  #   I had mega problems getting firefox/chrome driver to work properly on
  # Appveyor, so I'm using IE here instead.
  browser = :ie
else
  browser = :firefox
end


if browser == :ie
  ie_caps = Selenium::WebDriver::Remote::Capabilities.ie("initialBrowserUrl" => test_url)
  ie_driver = Selenium::WebDriver.for :ie, :desired_capabilities => ie_caps, :http_client => client
  b = Watir::Browser.new ie_driver
else
  b = Watir::Browser.new browser, :http_client => client
  b.goto test_url
end

at_exit {
  b.close
}

# The actual test
begin
  b.div(:id => "result").wait_until_present(30)
  Watir::Wait.until(60, 'js-enabled') { b.text.include? 'js enabled' }
  Watir::Wait.until(60, 'swf-js') { b.text.include? 'success' }
rescue => e
  puts e
  exit 1
end


exit 0
