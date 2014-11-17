# JumioRock

Unofficial Jumio Netverify Integration

## Installation

Add this line to your application's Gemfile:

    gem 'jumio_rock'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jumio_rock

## Usage

### Config

    JumioRock::Configuration.configure do |config|
      config.api_token = "bb972bd6f677f498654de4772039711a"
      config.api_secret = "7c494434f4edc9c2ef3c56d499c9de3d"
    end

### Embed in Iframe
    @client = JumioRock::Client.new
    response = @client.init_embed(scan_reference, success_url, error_url, options = {})
    
### Embed in Iframe not ID document

    @client = JumioRock::Client.new
    response = @client.init_multidocument(document_type, merchant_scan_reference, customer_id, success_url, error_url, options = {})

### Redirect to Jumio platform

    @client = JumioRock::Client.new
    response = @client.init_redirect(scan_reference, customer_id, options = {})
    redirect_to response.clientRedirectUrl

### API
    client = JumioRock::Client.new
    response = client.call_api(scan_reference, front_side_image_path, options = {})

### In your view

After embed or multidocument initilization in your controller

    <%= raw @client.iframe %>