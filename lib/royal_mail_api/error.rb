module RoyalMailApi
  class Error
    attr_accessor :code, :description

    def initialize(error)
      return unless error.class.name == 'Hash' && error.any?

      @code = error[:error_code],
      @description = error[:error_description]
    end
  end
end
