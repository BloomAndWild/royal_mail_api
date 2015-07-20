module RoyalMailApi
  class ResponseHandler
    class << self
      def handle_response(response)
        Response.new(parse(response))
      end

      private

      def parse(response) 
        # parse response
      end
    end
  end
end
