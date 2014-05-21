require 'net/http'
require 'json'
module FormhubRuby
  class ApiConnector
    attr_reader :formname, :filetype, :username, :password, :data

    def initialize(args)  
      @username = args[:username] || FormhubRuby.configuration.username
      @password = args[:password] || FormhubRuby.configuration.password
      @formname = args[:formname]
      @filetype = args[:filetype] || 'json'
    end

    def fetch
      # CAN DO THAT A LATER STAGE: Define different url format
      # for different data point formats
      # uri = URI(form_uri)         
      uri = URI("http://formhub.org/#{@username}/forms/#{@formname}/api")
      req = Net::HTTP::Get.new(uri)
      req.basic_auth @username, @password
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      begin
        @data = JSON.parse(response.body)
      rescue
        raise 'API connection error'
      end
    end

    # private

    # CAN DO THAT A LATER STAGE: Define different data point formats
    # (now will default to JSON)

    # def form_uri
    #   case @filetype.downcase
    #   when 'json' then "http://formhub.org/#{@username}/forms/#{@formname}/api"
    #   when 'csv' then "http://formhub.org/#{@username}/forms/#{@formname}/data.csv"
    #   when 'xls' then "http://formhub.org/#{@username}/forms/#{@formname}/data.xls"
    #   end
    # end
  end
end

