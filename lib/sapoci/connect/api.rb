module SAPOCI
  module Connect
    class Api

      # Perform an OCI background search
      def self.search(url, keywords, hook_url, extra_params = nil)
        SAPOCI::Connect::Search.new(url, hook_url).search(keywords, extra_params)
      end
      
    end
  end
end

