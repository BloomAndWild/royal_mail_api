module RoyalMailApi
  class Client
    class << self
      attr_reader :config, :errors

      def configure
        raise ArgumentError, "block not given" unless block_given?

        @config = Config.new
        yield config
      end

      def errors
        @errors ||= {}
      end
    end
  end
end
