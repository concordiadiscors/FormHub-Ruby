require 'formhub_ruby/version'
require 'formhub_ruby/configuration'
require 'formhub_ruby/api_connector'

module FormhubRuby

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end