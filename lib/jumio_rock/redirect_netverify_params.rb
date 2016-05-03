module JumioRock
  class RedirectNetverifyParams < NetverifyParams
    attr_reader :merchantIdScanReference, :customerId
    attr_accessor :authorizationTokenLifetime

    def initialize(scan_reference, customer_id)
      @merchantIdScanReference = scan_reference
      @customerId = customer_id
    end
  end
end
