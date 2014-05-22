require 'net/http'
require 'json'
require 'CGI'
module FormhubRuby
  class ApiConnector
    attr_reader :formname, :filetype, :username, :password, :data
    attr_accessor :query, :start, :limit


    def initialize(args) 
      @username = args[:username] || FormhubRuby.configuration.username
      @password = args[:password] || FormhubRuby.configuration.password
      @filetype = args[:filetype] || 'json'
      @formname = args[:formname]
      @query = args[:query]
      @start = args[:start] 
      @limit = args[:limit]
    end

    def fetch
      # CAN DO THAT A LATER STAGE: Define different url format
      # for different data point formats
      # uri = URI(form_uri)         
      uri = URI(api_uri)
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

    def api_uri
      "http://formhub.org/#{@username}/forms/#{@formname}/api" + api_parameters.to_s
    end

    def api_parameters
       if api_parameters_array.any?
          "?#{api_parameters_joined}"
       end
    end

    def api_query
      if @query
        "query=#{URI.escape @query.to_json}"
      end
    end

    def api_parameters_array
      [api_query, start, limit]
    end

    def api_parameters_joined
      api_parameters_array.compact.join('&')
    end

    def start
      if @start
        "start=#{@start.to_s}"
      end
    end

    def limit
      if @limit
        "limit=#{@limit.to_s}"
      end
    end

    # end
  end
end

