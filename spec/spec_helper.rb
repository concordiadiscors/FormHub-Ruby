require 'vcr'
require 'webmock'
require 'webmock/rspec'
require 'yaml'
require 'cgi'

RSpec.configure do |config|
  config.include WebMock::API
  config.before(:each) do
    WebMock.reset!
    VCR.configure do |c|
      c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
      c.allow_http_connections_when_no_cassette = true
      c.hook_into :webmock

      # Created a yml file with credentials 
      # ignored by git repository

      
      c.filter_sensitive_data('<USERNAME>') { ENV['FORMHUB_USERNAME'] }
      c.filter_sensitive_data('<PASSWORD>') { CGI.escape ENV['FORMHUB_PASSWORD'] }
      c.filter_sensitive_data('<PASSWORD>') { ENV['FORMHUB_PASSWORD'] }

      
    end

  end
end
