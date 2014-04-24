module JumioRock
  class Configuration
    attr_accessor :app_name, :company_name, :version, :url, :api_token, :api_secret

    def initialize
      self.company_name = 'YOURCOMPANYNAME'
      self.app_name = 'YOURAPPLICATIONNAME'
      self.version = VERSION
      self.url = "netverify.com/api/netverify/v2/performNetverify"
    end

    def self.configuration
      @configuration ||=  Configuration.new
    end

    def self.configure
      yield(configuration) if block_given?
    end

  end
end