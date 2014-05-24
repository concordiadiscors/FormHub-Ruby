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
  

  context 'when connecting to the API' do
    

    it 'successfully connects to the FormHub API and retrieve JSON Data' do
      VCR.use_cassette 'successful_connection' do 
        connection = FormhubRuby::ApiConnector.new(formname: 'survey')
        connection.fetch
        expect(connection.data).to be_a_kind_of(Array)
        expect(connection.data[0]).to be_a_kind_of(Object)
      end
    end

    it 'displays appropriate message if the JSON data is not successfully retrieved' do
      stub_request(:any, "http://formhub.org/#{FormhubRuby.configuration.username}/forms/survey/api").to_return(:body => 'NO JSON HERE')
      connection = FormhubRuby::ApiConnector.new(formname: 'fake')
      expect {connection.fetch}.to raise_error('API connection error')
    end
  end

  context 'when formulating a more complex query string' do

    let(:connection) {FormhubRuby::ApiConnector.new(formname: 'survey')}
    let(:username) {FormhubRuby.configuration.username}

    it "does not add any extraneaous query" do
       connection = FormhubRuby::ApiConnector.new(formname: 'survey')
       expect(connection.api_uri).to eq("http://formhub.org/#{username}/forms/survey/api")
    end

    it "does form a simple query" do
      connection.query = {age: 12}
      expect(connection.api_uri).to eq("http://formhub.org/#{username}/forms/survey/api?query=%7B%22age%22%3A%2212%22%7D")
      VCR.use_cassette 'age_query' do
        connection.fetch
        expect(connection.data.length).to eq(1)
      end

    end

    it "formulates a query with a start" do
      connection.start = 1
      expect(connection.api_uri).to eq("http://formhub.org/#{username}/forms/survey/api?start=1")
      VCR.use_cassette 'query_start' do
        connection.fetch
        expect(connection.data.length).to eq(1)
      end
    end

    it "formulates a query with a limit" do
      connection.limit = 1
      expect(connection.api_uri).to eq("http://formhub.org/#{username}/forms/survey/api?limit=1")
      VCR.use_cassette 'query_limit' do
        connection.fetch
        expect(connection.data.length).to eq(1)
      end
    end
    
  end

end

