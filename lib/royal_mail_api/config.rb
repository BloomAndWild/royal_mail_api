module RoyalMailApi
  class Config
    attr_accessor :username, :password

    def base_uri
      'http://www.royalmailgroup.com'
    end
  end
end
