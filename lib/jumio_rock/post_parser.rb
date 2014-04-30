module JumioRock
  class PostParser
    attr_reader :params

    def initialize(params)
      @params = params
      @params.keys.each do |method|
        self.class.send(:define_method, method) do
          return @params[method] if @params.has_key?(method)
          nil
        end
      end
    end

    def verified?
      idScanStatus == "SUCCESS"
    end

    def status
      (callBackType == "NETVERIFYID") ? verificationStatus : documentStatus
    end

  end
end