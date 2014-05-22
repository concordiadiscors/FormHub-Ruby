require 'formhub_ruby'
require 'spec_helper'
require 'yaml'

describe FormhubRuby::ApiConnector do

  

  context 'when connecting to the API' do
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

    it 'displays appropriate message if the JSON data is not successfully retrieved' do
      stub_request(:any, "http://formhub.org/#{FormhubRuby.configuration.username}/forms/survey/api").to_return(:body => 'NO JSON HERE')
      connection = FormhubRuby::ApiConnector.new(formname: 'fake')
      expect {connection.fetch}.to raise_error('API connection error')
    end
  end

  context 'when formulating the query string' do
    before :each do
      FormhubRuby.configure do |config|
        config.username = 'dummy_user'
        config.password = 'dummy_password'
      end
    end

    it "does not add any extraneaous query" do
       connection = FormhubRuby::ApiConnector.new(formname: 'survey')
       connection.api_uri.should == 'http://formhub.org/dummy_user/forms/survey/api'
    end

    it "does form a simple query" do
      connection = FormhubRuby::ApiConnector.new(formname: 'survey')
      connection.query = {age: 31}
      connection.api_uri.should == 'http://formhub.org/dummy_user/forms/survey/api?query=%7B%22age%22:31%7D'
    end

    it "formulates a query with a start" do
      connection = FormhubRuby::ApiConnector.new(formname: 'survey')
      connection.start = 3
      connection.api_uri.should == 'http://formhub.org/dummy_user/forms/survey/api?start=3'
    end

    it "formulates a query with a limit" do
      connection = FormhubRuby::ApiConnector.new(formname: 'survey')
      connection.limit = 3
      connection.api_uri.should == 'http://formhub.org/dummy_user/forms/survey/api?limit=3'
    end
      
  end

end

