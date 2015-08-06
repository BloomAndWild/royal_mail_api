module RoyalMailApi
  class ResponseHandler
    class << self
      def handle_response(response)
        Response.new(response)
      end
    end
  end
end
