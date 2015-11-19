# RoyalMailApi

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/royal_mail_api`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'royal_mail_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install royal_mail_api

## Usage

in initializers/royal_mail_api.rb

```ruby
  RoyalMailApi::Client.configure do |config|
    config.application_id = 'your Royal Mail application id'
    config.username = 'your Royal Mail username'
    config.password = ''your Royal Mail password'
    config.adapter = library used for http requests (eg. httpclient, excon)
    config.wsdl = 'path to your wsdl file'
    config.ssl_ca_cert_file = 'path to your Royal Mail ca cert file'
    config.ssl_cert_file = 'path to your Royal Mail cert file'
    config.ssl_cert_key_file = 'path to your Royal Mail key file'
    config.endpoint = api endpoint for sandbox/production (eg. "https://api.royalmail.com/shipping/onboarding")
    config.logger = Logger.new(STDOUT)
  end
```

### to make a request

```ruby
  RoyalMailApi::RequestHandler.request(type, attrs)
```

#### types:

create_shipment

```ruby
  attrs = {
    transaction_id: unique identifier, preferably the id of the delivery in your system,
    shipping_date: format ('%Y-%m-%d'),
    user_name: '',
    email: '',
    address_line1: '',
    post_town: '',
    post_code: '',
    weight: weight of letter/parcel,
    country_code: addressee's number's country code,
    telephone_number: ''
  }

  RoyalMailApi::RequestHandler.request(:create_shipment, attrs)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/royal_mail_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## config adapter
  To make sure that savon can make the requests you may have to install another library to use as an adapter:

  https://github.com/savonrb/savon/issues/679
  https://github.com/savonrb/savon/issues/491
  https://github.com/savonrb/savon/issues/297

  This is a consistent issue, so best to play around. 
