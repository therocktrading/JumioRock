require 'json'

module JumioRock
  
  class NetverifyParams
    
    def to_json
      JSON.generate(params)
    end

    private 

    def params
      data = {}
      self.instance_variables.each do |v|
        name = v.to_s.sub('@', '')
        data[name] = self.send(name)
      end
      check_mandatory(data)
      data
    end

    # attr_reader instance variables must be set 
    def check_mandatory(data)
      required_params = self.instance_variables.select{|v| !respond_to?("#{v.to_s.gsub('@','')}=")}
      required_params.each do |r|
        name = r.to_s.sub('@', '')
        raise "#{name} is a required param" unless data[name]
      end
    end
  end

end