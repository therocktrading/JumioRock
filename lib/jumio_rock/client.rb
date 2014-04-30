module JumioRock
  class Client
    attr_reader :authorization_token
    attr_accessor :api_url, :init_embed_url, :init_redirect_url, :multi_document_url
    
    def initialize
      @api_url = conf.api_url
      @init_embed_url = conf.init_embed_url
      @init_redirect_url = conf.init_redirect_url
      @multi_document_url = conf.multi_document_url
    end

    def call_api(scan_reference, front_side_image_path, options = {})
      body = PerformNetverifyParams.new(scan_reference, front_side_image_path)
      body = set_options body, options
      post(api_url, body.to_json)
    end

    def init_embed(scan_reference, success_url, error_url, options = {})
      body = EmbedNetverifyParams.new(scan_reference, success_url, error_url)
      body = set_options body, options
      response = post(init_embed_url, body.to_json)
      @authorization_token = response.authorizationToken
      response
    end

    def init_redirect(scan_reference, customer_id, options = {})
      body = RedirectNetverifyParams.new(scan_reference, customer_id)
      body = set_options body, options
      post(init_redirect_url, body.to_json)
    end

    def init_multidocument(document_type, merchant_scan_reference, customer_id, success_url, error_url, options = {})
      body = MultiDocumentNetverifyParams.new(document_type, merchant_scan_reference, customer_id, success_url, error_url)
      body = set_options body, options
      response = post(multi_document_url, body.to_json)
      @authorization_token = response.authorizationToken
      response
    end

    def embed(locale = "en")
      iframe(locale, "initVerify")
    end

    def embed_multi(locale = "en")
      iframe(locale, "initMDM")
    end

    def iframe(locale = "en", type = "initVerify")
      <<-TEXT
        <script type="text/javascript" src="https://netverify.com/widget/jumio-verify/2.0/iframe-script.js"> </script>
        <script type="text/javascript">
          /*<![CDATA[*/
          JumioClient.setVars({
          authorizationToken: "#{authorization_token}",
          locale: "#{locale}"
          }).#{type}("JUMIOIFRAME");
          /*]]>*/
        </script>
      TEXT
    end

    private

    def set_options(body, options)
      options.each do |k, v|
        body.send("#{k}=", v)
      end
      body
    end

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