require 'openssl'
require 'base64'
require 'savon'
require 'digest/sha1'
require "active_support/core_ext/string"

require "royal_mail_api/version"
require 'royal_mail_api/hash_methods'
require 'royal_mail_api/config'
require 'royal_mail_api/request_handler'
require 'royal_mail_api/xml_builder'
require 'royal_mail_api/response_handler'
require 'royal_mail_api/response'
require 'royal_mail_api/client'
require 'royal_mail_api/error'
require 'royal_mail_api/warning'

module RoyalMailApi
  def self.root
    File.dirname __dir__
  end
end
