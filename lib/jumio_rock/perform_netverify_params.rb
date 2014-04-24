require 'json'

module JumioRock
  
  class PerformNetverifyParams
    REQUIRED = ['merchantIdScanReference', 'frontsideImage']
    IMAGE_MAX_SIZE = 5 *1024 *1014

    attr_accessor :callbackUrl
    attr_reader :merchantIdScanReference, :frontsideImage

    def initialize(scan_reference, front_side_image_path)
      @merchantIdScanReference = scan_reference
      encode_image front_side_image_path
    end

    def to_json
      JSON.generate(params)
    end

    private 

    def encode_image(path)
      file = File.read(path)
      encode(file)
    end

    def encode(str)
      image_base64 = Base64.encode64(str)
      raise "image max size 5MB"  unless check_image_size(image_base64.bytesize())
      @frontsideImage = image_base64.gsub(/\n/, "")
    end

    def params
      data = {}
      self.instance_variables.each do |v|
        name = v.to_s.sub('@', '')
        data[name] = self.send(name)
      end
      check_mandatory(data)
      data
    end

    def check_mandatory(data)
      REQUIRED.each do |r|
        raise "#{r} is a required param" unless data[r]
      end
    end

    def check_image_size(bytesize)
      bytesize < IMAGE_MAX_SIZE
    end
  end

end