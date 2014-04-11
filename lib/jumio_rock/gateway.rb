module JumioRock
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
end