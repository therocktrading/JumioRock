require_relative '../../minitest_helper'
require 'chunky_png'

describe JumioRock::PerformNetverifyParams do
 
  it "must check required params" do
    pnp = JumioRock::PerformNetverifyParams.new
    proc { pnp.to_json }.must_raise RuntimeError
  end
 
  it "create json based on instace variables" do
    fields = ["merchantIdScanReference", "frontsideImage"]
    pnp = JumioRock::PerformNetverifyParams.new
    fields.each{|f| pnp.send("#{f}=", "value")}
    json = pnp.to_json
    object = JSON.parse(json)
    fields.each do |f|
      object.keys.must_include f
    end
  end

  it 'encode image' do 
    path = create_test_image
    
    pnp = JumioRock::PerformNetverifyParams.new
    pnp.encode_image(path)
    assert_equal pnp.frontsideImage, "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAgMAAABinRfyAAAACVBMVEUAAAAAAAAKFB5aVYYgAAAAA3RSTlMAgIAsTd+1AAAAFUlEQVR4nGNiAAImFRBxB0QwUEgAAEtUASFOz9UDAAAAAElFTkSuQmCC"
  end
end