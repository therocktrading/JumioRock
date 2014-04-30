module JumioRock
  
  class EmbedNetverifyParams < NetverifyParams 
    
    attr_reader :merchantIdScanReference, :successUrl, :errorUrl
    attr_accessor :enabledFields, :authorizationTokenLifetime, :merchantReportingCriteria, 
      :callbackUrl, :locale, :clientIp, :customerId, :firstName, :lastName, :country, 
      :usState, :expiry, :number, :dob, :idType, :personalNumber, :mrzCheck, :additionalInformation

    def initialize(scan_reference, success_url, error_url)
      @merchantIdScanReference = scan_reference
      @successUrl = success_url
      @errorUrl = error_url
    end

  end

end