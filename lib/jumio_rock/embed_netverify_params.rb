module JumioRock
  
  class EmbedNetverifyParams < NetverifyParams 
    
    attr_reader :merchantIdScanReference, :successUrl, :errorUrl

    def initialize(scan_reference, success_url, error_url)
      @merchantIdScanReference = scan_reference
      @successUrl = success_url
      @errorUrl = error_url
    end

  end

end