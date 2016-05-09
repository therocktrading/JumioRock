module JumioRock
  class Client
    attr_reader :authorization_token
    attr_accessor :api_url, :init_embed_url, :init_redirect_url, :multi_document_url, :retrieval_url

    def initialize
      @api_url = conf.api_url
      @init_embed_url = conf.init_embed_url
      @init_redirect_url = conf.init_redirect_url
      @multi_document_url = conf.multi_document_url
      @retrieval_url = conf.retrieval_url
      @initialization_type = nil
    end

    def call_api(scan_reference, front_side_image_path, options = {})
      body = PerformNetverifyParams.new(scan_reference, front_side_image_path)
      body = set_options body, options
      post(api_url, body.to_json)
    end

    def init_embed(scan_reference, success_url, error_url, options = {})
      @initialization_type = :embed
      body = EmbedNetverifyParams.new(scan_reference, success_url, error_url)
      body = set_options body, options
      response = post(init_embed_url, body.to_json)
      @authorization_token = response.authorizationToken
      response
    end

    def init_redirect(scan_reference, customer_id, options = {})
      @initialization_type = :redirect
      body = RedirectNetverifyParams.new(scan_reference, customer_id)
      body = set_options body, options
      post(init_redirect_url, body.to_json)
    end

    def init_multidocument(document_type, merchant_scan_reference, customer_id, success_url, error_url, options = {})
      @initialization_type = :multi
      body = MultiDocumentNetverifyParams.new(document_type, merchant_scan_reference, customer_id, success_url, error_url)
      body = set_options body, options
      response = post(multi_document_url, body.to_json)
      @authorization_token = response.authorizationToken
      response
    end

    def retrieve(scan_reference)
      @initialization_type = :retrieveirb
      url = File.join(retrieval_url, scan_reference.to_s).to_s
      get(url)
    end

    def iframe(locale = "en")
      iframe_html(locale, js_type)
    end

    def iframe_html(locale = "en", type = "initVerify")
      <<-TEXT
        #{self.class.jumio_js}
        <script type="text/javascript">
          /*<![CDATA[*/
          #{js_request(locale, type)}
          /*]]>*/
        </script>
      TEXT
    end

    def js(locale = "en")
      js_request(locale, js_type)
    end

    def js_request(locale, type)
      <<-TEXT
        JumioClient.setVars({
          authorizationToken: \"#{authorization_token}\",
          locale: \"#{locale}\"
        }).#{type}(\"JUMIOIFRAME\");
      TEXT
    end

    def self.jumio_js
      '<script type="text/javascript" src="https://netverify.com/widget/jumio-verify/2.0/iframe-script.js"> </script>'
    end

    private

    def js_type
      raise "Client not initialized (init_embed or init_multidocument)" unless @initialization_type
      @initialization_type == :multi ? "initMDM" : "initVerify"
    end

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

    def get(url)
      connection = Excon.new(url, user: conf.api_token, password: conf.api_secret)

      response = connection.request(
        method: 'GET',
        headers: headers
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
