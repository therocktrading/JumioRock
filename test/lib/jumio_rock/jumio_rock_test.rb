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

def success_api_response
  "idExpiry=2022-12-31&idType=PASSPORT&idDob=1990-01-01&idCheckSignature=OK&idCheckDataPositions=OK&idCheckHologram=OK&idCheckMicroprint=OK&idCheckDocumentValidation=OK&idCountry=USA&idScanSource=WEB_UPLOAD&idFirstName=FIRSTNAME&verificationStatus=APPROVED_VERIFIED&jumioIdScanReference=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&personalNumber=N%2FA&merchantIdScanReference=YOURIDSCANREFERENCE&idCheckSecurityFeatures=OK&idCheckMRZcode=OK&idScanImage=https%3A%2F%2Fnetverify.com%2Frecognition%2Fv1%2Fidscan%2Fxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx%2Ffront&callBackType=NETVERIFYID&clientIp=xxx.xxx.xxx.xxx&idLastName=LASTNAME&idAddress=%7B%22country%22%3A%22USA%22%2C%22state%22%3A%22OH%22%7D&idScanStatus=SUCCESS&idNumber=P1234"
end

def unsuccess_api_response
end

def parse_post(str)
  params = {}
  splitted_values = str.split('&')
  splitted_values.each do |v|
    kv = v.match(/^([\w\W]+)=([\w\W]+)/)
    params[kv[1].to_sym] = kv[2]
  end
  params
end

describe JumioRock::Gateway do
  before :once do 
    JumioRock::Configuration.configure do |config|
      config.userid = "username"
      config.password = "password"
    end
  end
  
  it "should post image" do 
    gateway = JumioRock::Gateway.new
    stub_api_request

    response = gateway.call
    assert_equal response.timestamp, "2012-08-16T10:37:44.623Z"

  end

  it "parse post" do 
    params = parse_post(success_api_response)
    pp = JumioRock::PostParser.new(params)
    assert_equal("2022-12-31", pp.idExpiry)
  end

end