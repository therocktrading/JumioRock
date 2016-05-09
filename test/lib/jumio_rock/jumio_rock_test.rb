require_relative '../../minitest_helper'

describe JumioRock::Client do
  before :once do
    JumioRock::Configuration.configure do |config|
      config.api_token = "username"
      config.api_secret = "password"
    end
    @path = image_path
  end

  it "should post image using api" do
    stub_api_request

    client = JumioRock::Client.new
    response = client.call_api("1", @path)
    assert_equal response.timestamp, "2012-08-16T10:37:44.623Z"

  end

  it 'initialize embed iframe' do
    stub_init_embed_request

    auth_token = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    client = JumioRock::Client.new
    response = client.init_embed("scanID", "http://success_url", "http://error_url")

    assert_equal response.authorizationToken, auth_token
    iframe = client.iframe response.authorizationToken
    assert_match auth_token, iframe

  end

  it 'initialize multi document' do
    stub_multi_document_request
    auth_token = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    client = JumioRock::Client.new
    response = client.init_multidocument('CC',"YOURSCANREFERENCE", "CUSTOMERID","https://95.240.235.90/success", "https://95.240.235.90/error")

    assert_equal response.authorizationToken, auth_token

    iframe = client.iframe response.authorizationToken
    assert_match auth_token, iframe

  end

  it 'initialize redirect' do
    stub_redirect_request
    auth_token = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    client = JumioRock::Client.new
    response = client.init_redirect("scan_id", "customer_id")

    assert_equal response.clientRedirectUrl, "https://[your-domain-prefix].netverify.com/v2?authorizationToken=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  end

  it 'retrieve scan status' do
    stub_retrieval_request

    client = JumioRock::Client.new
    response = client.retrieve("scan_id")

    assert_equal response.scanReference, "scan_id"
    assert_equal response.status, "DONE"
  end

  it "success response" do
    params = parse_post(success_api_response)
    pp = JumioRock::PostParser.new(params)
    assert_equal("APPROVED_VERIFIED", pp.status)
  end

  it "fraud response" do
    params = parse_post(fraud_api_response)
    pp = JumioRock::PostParser.new(params)
    refute_same("APPROVED_VERIFIED", pp.status)
  end


end
