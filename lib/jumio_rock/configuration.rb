module JumioRock
  class Configuration
    attr_accessor :app_name, :company_name, :version, :api_url, :api_token, :api_secret, :init_redirect_url, :init_embed_url

    def initialize
      self.company_name = 'YOURCOMPANYNAME'
      self.app_name = 'YOURAPPLICATIONNAME'
      self.version = VERSION
      self.api_url = "https://netverify.com/api/netverify/v2/performNetverify"
      self.init_redirect_url = "https://netverify.com/api/netverify/v2/initiateNetverifyRedirect"
      self.init_embed_url = "https://netverify.com/api/netverify/v2/initiateNetverify"
    end

    def self.configuration
      @configuration ||=  Configuration.new
    end

    def self.configure
      yield(configuration) if block_given?
    end

  end
end