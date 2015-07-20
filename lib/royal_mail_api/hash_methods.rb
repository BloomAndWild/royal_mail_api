require "active_support/core_ext/string"

module RoyalMailApi
  module HashMethods
    def symbolize_keys(h)
      if Hash === h
        Hash[
          h.map do |k, v| 
            [k.respond_to?(:to_sym) ? k.underscore.to_sym : k, symbolize_keys(v)] 
          end 
        ]
      elsif Array === h
        h.map { |hash| symbolize_keys(hash) }
      else
        h
      end
    end

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
