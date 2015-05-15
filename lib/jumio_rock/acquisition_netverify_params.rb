module JumioRock

  class AcquisitionNetverifyParams < NetverifyParams

    attr_reader :type, :country, :merchantScanReference, :customerId
    attr_accessor :authorizationTokenLifetime, :merchantReportingCriteria,
      :successUrl, :errorUrl, :callbackUrl, :clientIp

    def initialize(document_type, country, merchant_scan_reference, customer_id) # , success_url, error_url)
      @type                  = document_type
      @country               = country
      @merchantScanReference = merchant_scan_reference
      @customerId            = customer_id
      # @successUrl            = success_url
      # @errorUrl              = error_url
    end

  end

end
