module CoreExt
  class HashMethods
    class << self
      def retrieve_value(obj,key)
        if obj.respond_to?(:key?) && obj.key?(key)
          return obj[key]
        elsif obj.is_a?(Hash) or obj.is_a?(Array)
          r = nil
          obj.find{ |*a| r=retrieve_value(a.last,key) }
          return r
        end
      end
    end
  end
end
