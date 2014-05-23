require 'vcr'
require 'webmock'
require 'webmock/rspec'
require 'yaml'
require 'cgi'

RSpec.configure do |config|
  FactoryGirl.find_definitions

  config.include WebMock::API
  config.before(:each) do
    WebMock.reset!
    VCR.configure do |c|
      c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
      c.allow_http_connections_when_no_cassette = true
      c.hook_into :webmock

      # Created a yml file with credentials 
      # ignored by git repository
      credentials = YAML.load_file('spec/fixtures/test_credentials.yml')
      
      c.filter_sensitive_data('<USERNAME>') { credentials['username'] }
      c.filter_sensitive_data('<PASSWORD>') { CGI.escape credentials['password'] }
      c.filter_sensitive_data('<PASSWORD>') { credentials['password'] }

      
    end

  end
end
