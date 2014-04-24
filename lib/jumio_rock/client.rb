module JumioRock
  class Client
    attr_accessor :api_url, :init_embed_url, :init_redirect_url, :multi_document_url
    
    def initialize
      @api_url = conf.api_url
      @init_embed_url = conf.init_embed_url
      @init_redirect_url = conf.init_redirect_url
      @multi_document_url = conf.multi_document_url
    end

    def call_api(body)
      post(api_url, body)
    end

    def init_embed(body)
      post(init_embed_url, body)
    end

    def init_redirect(body)
      post(init_redirect_url, body)
    end

    def init_multidocument(body)
      post(multi_document_url, body)
    end

    def iframe(authorization_token, locale = "en")
      <<-TEXT
        <script type="text/javascript" src="https://netverify.com/widget/jumio-verify/2.0/iframe-script.js"> </script>
        <script type="text/javascript">
          /*<![CDATA[*/
          JumioClient.setVars({
          authorizationToken: "#{authorization_token}",
          locale: "#{locale}"
          }).initVerify("JUMIOIFRAME");
          /*]]>*/
        </script>
      TEXT
    end

    private

    def post(url, body)
      connection = Excon.new(url, :user => conf.api_token, :password => conf.api_secret)
      response = connection.request(
        method: 'POST',
        headers: headers,
        body: body
      )
      OpenStruct.new JSON.parse(response.body)
    end

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