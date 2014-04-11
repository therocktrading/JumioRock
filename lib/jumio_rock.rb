require "jumio_rock/version"
require "jumio_rock/perform_netverify_params"

require 'excon'
require "base64"

module JumioRock

  class Configuration
    attr_accessor :app_name, :company_name, :version, :url, :userid, :password

    def initialize
      self.company_name = 'YOURCOMPANYNAME'
      self.app_name = 'YOURAPPLICATIONNAME'
      self.version = VERSION
      self.url = "https://netverify.com/api/netverify/v2/performNetverify"
    end

    def self.configuration
      @configuration ||=  Configuration.new
    end

    def self.configure
      yield(configuration) if block_given?
    end

  end
  
  class Gateway

    attr_accessor :endpoint_url, :data

    def initialize
      @endpoint_url = conf.url
    end

    def call
      connection = Excon.new(endpoint_url, :user => conf.userid, :password => conf.password)
      response = connection.request(
        method: 'get',
        headers: headers
      )
      OpenStruct.new JSON.parse(response.body)
    end

    private

    def conf
      Configuration.configuration
    end

    def headers
      { 
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'User-Agent' => "#{conf.company_name} #{conf.app_name}/#{conf.version}",
        'Authorization' => 'Basic'
      }
    end

  end

  class PostParser
    attr_reader :params

    def initialize(params)
      @params = params
      @params.keys.each do |method|
        self.class.send(:define_method, method) do
          return @params[method] if @params.has_key?(method)
          nil
        end
      end
    end

  end
  
end
