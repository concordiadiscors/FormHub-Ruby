require 'vcr'
require 'webmock'
require 'webmock/rspec'
require 'factory_girl'

RSpec.configure do |config|
  FactoryGirl.find_definitions

  config.include WebMock::API
  config.before(:each) do
    WebMock.reset!
    VCR.configure do |c|
      c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
      c.allow_http_connections_when_no_cassette = true
      c.hook_into :webmock
      # c.before_record do |i|

      #   i.response.headers.delete('Set-Cookie')
      #   i.request.headers.delete('Authorization')

      #   u = URI.parse(i.request.uri)
      #   i.request.uri.sub!(%r{:\/\/.*#{Regexp.escape(u.host)}}, "://#{u.host}")

      # end

      # Matches authenticated requests regardless of their Basic
      # auth string (https://user:pass@domain.tld)
      # c.register_request_matcher :anonymized_uri do |request_1, request_2|
      #   (URI(request_1.uri).port == URI(request_2.uri).port) &&
      #     URI(request_1.uri).path == URI(request_2.uri).path
      # end
    end

  end
end
