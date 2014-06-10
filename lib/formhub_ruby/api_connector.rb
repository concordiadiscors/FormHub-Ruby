require 'net/http'
require 'json'
require 'cgi'
require 'addressable/uri'

module FormhubRuby
  class ApiConnector
    attr_reader :formname, :filetype, :username, :password, :data
    attr_accessor :query, :start, :limit, :sort, :fields, :cast_integers


    def initialize(args) 
      @username = args[:username] || FormhubRuby.configuration.username
      @password = args[:password] || FormhubRuby.configuration.password
      @filetype = args[:filetype] || 'json'
      @formname = args[:formname]
      @query = args[:query]
      @start = args[:start] 
      @limit = args[:limit]
      @sort = args[:sort]
      @fields = args[:fields]
      @cast_integers = args[:cast_integers] || false
      @data = []
    end

    def fetch
      get_response(api_uri)
    end

    def get_count
      response = get_response("#{api_uri}&count=1")
      response[0]['count']
    end




    # private

    def get_response(custom_uri)
      uri = URI(custom_uri)
      req = Net::HTTP::Get.new(uri)
      req.basic_auth @username, @password
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      begin
        returned_data = JSON.parse(response.body)
        @data = if @cast_integers
                  returned_data.map do |row|
                    Hash[ row.map { |a, b| [a, cast_to_value_to_int(b)] } ]
                  end
                else 
                 returned_data
                end
      
      rescue
        raise 'API connection error'
      end
    end


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
        "query=#{CGI.escape stringify_hash_values(@query).to_json}"
      end
    end

    def api_parameters_array
      [api_query, start, limit, sort_query, fields_query]
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

    def stringify_hash_values(hash)
      hash.merge(hash){|k,hashv|hashv.to_s}
    end

    # Note that integers seem to be stored as strings in Formhub database,
    # and will be sorted as such

    def sort_query
      if @sort
        validates_sort
        "sort=#{CGI.escape @sort.to_json}"
      end
    end

    def fields_query
      if @fields
        "fields=#{CGI.escape  @fields.to_json}"  
      end    
    end

    def validates_sort
      unless @sort.values.all? { |value| value == 1 || value == -1}
        raise 'The sort option is hash taking +1 (ascending) or -1 (descending) value '
      end

    end

    def cast_to_value_to_int(str)
      begin
        Integer(str)
      rescue ArgumentError, TypeError
        str
      end
    end

  end
end

