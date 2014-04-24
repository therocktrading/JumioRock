module JumioRock
  
  class MultiDocumentNetverifyParams < NetverifyParams 
    
    attr_reader :documentType, :merchantScanReference, :customerID, :successUrl, :errorUrl
    attr_accessor :authorizationTokenLifetime, :merchantReportingCriteria, :callbackUrl, :clientIp

    def initialize(document_type, merchant_scan_reference, customer_id, success_url, error_url)
      @documentType = document_type
      @merchantScanReference = merchant_scan_reference
      @customerID = customer_id
      @successUrl = success_url
      @errorUrl = error_url
    end

  end

end