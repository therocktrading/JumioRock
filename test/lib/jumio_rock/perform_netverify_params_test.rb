require_relative '../../minitest_helper'
require 'chunky_png'

describe JumioRock::PerformNetverifyParams do
  before :once do
    @path = image_path
  end

  it "must check required params" do
    pnp = JumioRock::PerformNetverifyParams.new(nil, @path)
    proc { pnp.to_json }.must_raise RuntimeError
  end

  it "create json based on instace variables" do
    fields = ["merchantIdScanReference", "frontsideImage"]
    pnp = JumioRock::PerformNetverifyParams.new("scanID", @path)
    json = pnp.to_json
    object = JSON.parse(json)
    fields.each do |f|
      object.keys.must_include f
    end
  end

  it 'encode image' do
    pnp = JumioRock::PerformNetverifyParams.new("scanID", @path)
    assert_equal pnp.frontsideImage, "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAgMAAABinRfyAAAACVBMVEUAAAAAAAAKFB5aVYYgAAAAA3RSTlMAgIAsTd+1AAAAFUlEQVR4nGNiAAImFRBxB0QwUEgAAEtUASFOz9UDAAAAAElFTkSuQmCC"
  end
end
