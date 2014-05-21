module FormhubRuby
  class Configuration
    attr_accessor :username, :password

    def initialize(args={})
      @username = args[:username]
      @password = args[:password]
    end
  end
end