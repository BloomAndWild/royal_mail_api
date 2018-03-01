$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'royal_mail_api'
require 'dotenv'

Dotenv.load

require_relative 'support/fixtures/responses/parsed_responses'
require_relative 'support/helpers/client_helper'

require 'vcr'
require 'support/core_ext/hash_methods'
require 'support/matchers/have_hash_key'

VCR.configure do |c|
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost                        = true
  c.cassette_library_dir                    = 'spec/support/fixtures/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = false
  c.default_cassette_options                = { match_requests_on: [:uri] }
end
