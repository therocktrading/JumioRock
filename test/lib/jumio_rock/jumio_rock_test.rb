require_relative '../../minitest_helper'

def stub_api_request
  prefix = jumio_conf.url.match(/^https/) ? "https" : "http"
  url = jumio_conf.url.gsub(/http[s]:\/\//,'')
  stub_request(:get, "#{prefix}://#{jumio_conf.userid}:#{jumio_conf.password}@#{url}").
    with(:headers => {
      'Host'=>'netverify.com:443', 
      'User-Agent'=>"#{jumio_conf.company_name} #{jumio_conf.app_name}/#{jumio_conf.version}"
    }).
    to_return(:status => 200, :body => json_body, :headers => {})
end

def jumio_conf
  JumioRock::Configuration.configuration
end

def json_body
  <<-EOF
    {
    "timestamp": "2012-08-16T10:37:44.623Z",
    "jumioIdScanReference": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
  EOF
end

describe JumioRock::Gateway do
  before :each do 
    JumioRock::Configuration.configure do |config|
      config.userid = "username"
      config.password = "password"
    end
  end
  
  it "should post image" do 
    p JumioRock::Configuration.configuration
    gateway = JumioRock::Gateway.new
    stub_api_request

    response = gateway.call
    assert_equal response.timestamp, "2012-08-16T10:37:44.623Z"

  end
  

end