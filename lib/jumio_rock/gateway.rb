module JumioRock
  class Gateway
    attr_accessor :endpoint_url
    
    def initialize
      @endpoint_url = conf.url
    end

    def call(body)
      connection = Excon.new(endpoint_url, :user => conf.api_token, :password => conf.api_secret)
      response = connection.request(
        method: 'POST',
        headers: headers,
        body: body
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
        'User-Agent' => "#{conf.company_name} #{conf.app_name}/#{conf.version}"
      }
    end

  end
end