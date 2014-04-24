require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'

require File.expand_path('../../lib/jumio_rock.rb', __FILE__)

def create_test_image
  path = File.expand_path(File.join(File.dirname(__FILE__), "../../../tmp/filename.png"))

  png = ChunkyPNG::Image.new(16, 16, ChunkyPNG::Color::TRANSPARENT)
  png[1,1] = ChunkyPNG::Color.rgba(10, 20, 30, 128)
  png[2,1] = ChunkyPNG::Color('black @ 0.5')
  png.save(path)

  path
end

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

def stub_init_embed_request
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

def stub_multi_document_request 
  stub_request(:post, "https://username:password@netverify.com/api/netverify/v2/createDocumentAcquisition").
    with(:body => "{\"documentType\":\"CC\",\"merchantScanReference\":\"YOURSCANREFERENCE\",\"customerID\":\"CUSTOMERID\",\"successUrl\":\"https://95.240.235.90/success\",\"errorUrl\":\"https://95.240.235.90/error\"}",
       :headers => {'Accept'=>'application/json', 'Authorization'=>'Basic dXNlcm5hbWU6cGFzc3dvcmQ=', 'Content-Type'=>'application/json', 'Host'=>'netverify.com:443', 'User-Agent'=>'YOURCOMPANYNAME YOURAPPLICATIONNAME/0.0.1'}).
    to_return(:status => 200, :body => json_multi_document_response, :headers => {})
end

def stub_redirect_request
  stub_request(:post, "https://username:password@netverify.com/api/netverify/v2/initiateNetverifyRedirect").
    with(:body => "{\"merchantIdScanReference\":\"scan_id\",\"customerId\":\"customer_id\"}",
       :headers => {'Accept'=>'application/json', 'Authorization'=>'Basic dXNlcm5hbWU6cGFzc3dvcmQ=', 'Content-Type'=>'application/json', 'Host'=>'netverify.com:443', 'User-Agent'=>'YOURCOMPANYNAME YOURAPPLICATIONNAME/0.0.1'}).
    to_return(:status => 200, :body => json_redirect_response, :headers => {})
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

def json_multi_document_response
  <<-EOF
    {
      "timestamp": "2012-08-16T10:27:29.494Z",
      "authorizationToken": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "jumioIdScanReference": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
  EOF
end

def json_redirect_response
  <<-EOF
   {
      "timestamp": "2012-08-16T10:27:29.494Z",
      "authorizationToken": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "clientRedirectUrl": "https://[your-domain-prefix].netverify.com/v2?authorizationToken=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
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