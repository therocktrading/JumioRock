require_relative '../../minitest_helper'

def stub_api_request
  prefix = jumio_conf.api_url.match(/^https/) ? "https" : "http"
  url = jumio_conf.api_url.gsub(/http[s]:\/\//,'')
  stub_request(:post, "#{prefix}://#{jumio_conf.api_token}:#{jumio_conf.api_secret}@#{url}").
    with(:headers => {
      'Host'=>'netverify.com:443', 
      'User-Agent'=>"#{jumio_conf.company_name} #{jumio_conf.app_name}/#{jumio_conf.version}"
    }).
    to_return(:status => 200, :body => json_api_response, :headers => {})
end

def stup_init_embed_request
  stub_request(:post, "https://username:password@netverify.com/api/netverify/v2/initiateNetverify").
    with(
      :body => "{\"merchantIdScanReference\":\"scanID\",\"successUrl\":\"http://success_url\",\"errorUrl\":\"http://error_url\"}",
      :headers => {
        'Accept'=>'application/json', 
        'Authorization'=>'Basic dXNlcm5hbWU6cGFzc3dvcmQ=', 
        'Content-Type'=>'application/json', 
        'Host'=>'netverify.com:443', 
        'User-Agent'=>'YOURCOMPANYNAME YOURAPPLICATIONNAME/0.0.1'}).
    to_return(:status => 200, :body => json_init_embed_response, :headers => {})
end

def jumio_conf
  JumioRock::Configuration.configuration
end

def json_api_response
  <<-EOF
    {
    "timestamp": "2012-08-16T10:37:44.623Z",
    "jumioIdScanReference": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
  EOF
end

def json_init_embed_response
  <<-EOF
    {
      "timestamp": "2012-08-16T10:27:29.494Z",
      "authorizationToken": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "jumioIdScanReference": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
  EOF
end

def success_api_response
  "idExpiry=2022-12-31&idType=PASSPORT&idDob=1990-01-01&idCheckSignature=OK&idCheckDataPositions=OK&idCheckHologram=OK&idCheckMicroprint=OK&idCheckDocumentValidation=OK&idCountry=USA&idScanSource=WEB_UPLOAD&idFirstName=FIRSTNAME&verificationStatus=APPROVED_VERIFIED&jumioIdScanReference=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&personalNumber=N%2FA&merchantIdScanReference=YOURIDSCANREFERENCE&idCheckSecurityFeatures=OK&idCheckMRZcode=OK&idScanImage=https%3A%2F%2Fnetverify.com%2Frecognition%2Fv1%2Fidscan%2Fxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx%2Ffront&callBackType=NETVERIFYID&clientIp=xxx.xxx.xxx.xxx&idLastName=LASTNAME&idAddress=%7B%22country%22%3A%22USA%22%2C%22state%22%3A%22OH%22%7D&idScanStatus=SUCCESS&idNumber=P1234"
end

def fraud_api_response
  "idType=PASSPORT&idCheckSignature=N%2FA&rejectReason=%7B%20%22rejectReasonCode%22%3A%22100%22%2C%20%22rejectReasonDescription%22%3A%22MANIPULATED_DOCUMENT%22%2C%20%22rejectReasonDetails%22%3A%20%5B%7B%20%22detailsCode%22%3A%20%221001%22%2C%20%22detailsDescription%22%3A%20%22PHOTO%22%20%7D%2C%7B%20%22detailsCode%22%3A%20%221004%22%2C%20%22detailsDescription%22%3A%20%22DOB%22%20%7D%5D%7D&idCheckDataPositions=N%2FA&idCheckHologram=N%2FA&idCheckMicroprint=N%2FA&idCheckDocumentValidation=N%2FA&idCountry=USA&idScanSource=WEB_UPLOAD&verificationStatus=DENIED_FRAUD&jumioIdScanReference=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&merchantIdScanReference=YOURSCANREFERENCE&idCheckSecurityFeatures=N%2FA&idCheckMRZcode=N%2FA&idScanImage=https%3A%2F%2Fnetverify.com%2Frecognition%2Fv1%2Fidscan%2Fxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx%2Ffront&callBackType=NETVERIFYID&clientIp=xxx.xxx.xxx.xxx&idScanStatus=ERROR"
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

describe JumioRock::Client do
  before :once do 
    JumioRock::Configuration.configure do |config|
      config.api_token = "username"
      config.api_secret = "password"
    end
    @path = create_test_image
  end
  
  it "should post image using api" do 
    stub_api_request

    client = JumioRock::Client.new
    pnp = JumioRock::PerformNetverifyParams.new("1", @path)
    
    response = client.call_api pnp.to_json
    assert_equal response.timestamp, "2012-08-16T10:37:44.623Z"

  end

  it 'initialize embed iframe' do 
    stup_init_embed_request

    auth_token = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    client = JumioRock::Client.new
    pnp = JumioRock::EmbedNetverifyParams.new("scanID", "http://success_url", "http://error_url")
    response = client.init_embed pnp.to_json

    assert_equal response.authorizationToken, auth_token

    iframe = client.iframe response.authorizationToken
    assert_match auth_token, iframe

  end

  it "success response" do 
    params = parse_post(success_api_response)
    pp = JumioRock::PostParser.new(params)
    assert_equal(true, pp.success?)
  end

  it "fraud response" do
    params = parse_post(fraud_api_response)
    pp = JumioRock::PostParser.new(params)
    assert_equal(false, pp.success?)
  end


end