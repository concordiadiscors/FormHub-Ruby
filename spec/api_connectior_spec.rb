require 'formhub_ruby'
require 'spec_helper'
require 'yaml'

describe FormhubRuby::ApiConnector do

  before :each do
    credentials = YAML.load_file('spec/fixtures/test_credentials.yml')
    FormhubRuby.configure do |config|
      config.username = credentials['username']
      config.password = credentials['password']
    end
  end

  it 'successfully connects to the FormHub API and retrieve JSON Data' do
    VCR.use_cassette 'successful_connection' do 
      connection = FormhubRuby::ApiConnector.new(formname: 'survey')
      connection.fetch
      connection.data.should be_a_kind_of(Array)
      connection.data[0].should be_a_kind_of(Object)
    end
  end

  it "displays appropriate message if the JSON data is not successfully retrieved" do
      stub_request(:any, "http://formhub.org/#{FormhubRuby.configuration.username}/forms/survey/api").to_return(:body => "NO JSON HERE")
      connection = FormhubRuby::ApiConnector.new(formname: 'fake')
      expect {connection.fetch}.to raise_error("API connection error")
  end
end

