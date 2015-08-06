module RoyalMailApi
  class Warning
    attr_accessor :code, :description

    def initialize(warning)
      return unless warning.class.name == 'Hash' && warning.any?

      @code = warning[:warning_code],
      @description = warning[:warning_description]
    end
  end
end
