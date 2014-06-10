require 'formhub_ruby'
require 'spec_helper'
require 'yaml'

# Currently 4 records on my account for the survey form

describe FormhubRuby::ApiConnector do
  before :each do
    credentials = YAML.load_file('spec/fixtures/test_credentials.yml')
    FormhubRuby.configure do |config|
      config.username = credentials['username'] || 'fake'
      config.password = credentials['password'] || 'fake'
    end
  end

  let(:connection) {FormhubRuby::ApiConnector.new(formname: 'survey')}
  let(:username) {FormhubRuby.configuration.username}
  

  context 'when connecting to the API' do
    
    it 'appropriately converts data cast as strings in Formhub back to integers' do
      connection.query = {age: 18}
      connection.cast_integers = true

      expect(connection.api_uri).to eq("http://formhub.org/#{username}/forms/survey/api?query=%7B%22age%22%3A%2218%22%7D")
      VCR.use_cassette 'get_integer' do
        connection.fetch
        expect(connection.data.first['age']).to be_an(Integer)
      end
    end    

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



    it "does not add any extraneaous query" do
       connection = FormhubRuby::ApiConnector.new(formname: 'survey')
       expect(connection.api_uri).to eq("http://formhub.org/#{username}/forms/survey/api")
    end

    it "does form a simple query" do
      connection.query = {age: 18}

      expect(connection.api_uri).to eq("http://formhub.org/#{username}/forms/survey/api?query=%7B%22age%22%3A%2218%22%7D")
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
        expect(connection.data.length).to eq(3)
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

    it "combines a query with a start and a limit" do
      connection.start = 1
      connection.limit = 1
      expect(connection.api_uri).to eq("http://formhub.org/#{username}/forms/survey/api?start=1&limit=1")
      VCR.use_cassette 'query_start_and_limit' do
        connection.fetch
        expect(connection.data.length).to eq(1)
      end
    end


    it "just returns the count of rows for the query" do
     connection.start = 1
      connection.limit = 1
      VCR.use_cassette "just_get_the_count" do
        response = connection.get_count
        expect(response).to eq(4)
      end 

     end 


     it "sorts the data according to the supplied params" do

      connection.sort = {name: -1}

       VCR.use_cassette "sorts_properly" do
        connection.fetch
        expect(connection.data.map{|row| row["name"]}  ).to eq(['napoléon', 'loic', 'georges', 'Robert'])
       end 

      end 

      it "only retrieve the selected fields" do

       connection.fields = [:name, :age]

        VCR.use_cassette "retrieve_selected_fields_only" do
          connection.fetch
         expect(connection.data.first['pizza_fan']).to be_nil
         expect(connection.data.first['name']).not_to be_nil
        end



       end 

    
  end

end

