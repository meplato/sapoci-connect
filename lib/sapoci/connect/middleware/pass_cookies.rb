module SAPOCI
  module Connect
    module Middleware
      class PassCookies < Faraday::Response::Middleware
        def initialize(app, options = {})
          @options = options
          @cookies = []
          super(app)
        end

        def call(env)
          unless @cookies.empty?
            cookies = @cookies.compact.uniq.join("; ").squeeze(";")
            env[:request_headers]['Cookie'] = cookies
          end
          @app.call(env).on_complete do |resp|
            if cookie = resp[:response_headers]['Set-Cookie']
              @cookies << cookie
            end
          end
        end # call
      end
    end
  end
end
