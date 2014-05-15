require 'json'
require 'net/http'

module FormhubRuby
  class ApiConnector
    attr_accessor :formname, :filetype
    attr_reader :data
    USERNAME = 'concordiadiscors'
    PASSWORD = 'Z=n2ui79Z84ADBuc2@6FCt2n]'

    def initialize(formname, filetype)
        uri = URI("http://formhub.org/#{USERNAME}/forms/#{formname}/data.#{filetype}")
        puts uri
        req = Net::HTTP::Get.new(uri)
        req.basic_auth USERNAME, PASSWORD
        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
          http.request(req)
        }
        puts res.body
        begin
          res
        rescue
          raise "API connection error"
        end
    end
  end
end

connector = FormhubRuby::ApiConnector.new('survey', 'csv')
puts connector

# => 

# >> #<FormhubRuby::ApiConnector:0x007fa002921ce8>
# >> http://formhub.org/concordiadiscors/forms/survey/data.csv
# >> name,age,gender,photo,date,location,_location_latitude,_location_longitude,_location_altitude,_location_precision,pizza_fan,pizza_type,favorite_toppings/cheese,favorite_toppings/pepperoni,favorite_toppings/sausauge,favorite_toppings/green_peppers,favorite_toppings/mushrooms,favorite_toppings/anchovies,start_time,end_time,today,imei,phonenumber,meta/instanceID,_uuid,_submission_time
# >> georges,12,n/a,n/a,n/a,n/a,n/a,n/a,n/a,n/a,n/a,n/a,n/a,n/a,n/a,n/a,n/a,n/a,2014-05-15T17:28:43.000+01:00,2014-05-15T17:28:59.000+01:00,2014-05-15,enketo.formhub.org:fSucCmZ5zwzNcTe1,no phonenumber property in enketo,uuid:be1b882a-b377-4cf0-95d3-c2acc8d04e7a,be1b882a-b377-4cf0-95d3-c2acc8d04e7a,2014-05-15T16:29:00
# >> loic,23,female,n/a,n/a,n/a,n/a,n/a,n/a,n/a,no,n/a,n/a,n/a,n/a,n/a,n/a,n/a,2014-05-15T17:27:57.000+01:00,2014-05-15T17:28:18.000+01:00,2014-05-15,enketo.formhub.org:fSucCmZ5zwzNcTe1,no phonenumber property in enketo,uuid:2aebfa29-6284-4c3a-9c3f-6eb604f89194,2aebfa29-6284-4c3a-9c3f-6eb604f89194,2014-05-15T16:28:19
# >> #<FormhubRuby::ApiConnector:0x007fe7c3195b60>