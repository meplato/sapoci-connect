module SAPOCI
  module Connect
    module Middleware
      class RedirectLimitReached < Faraday::Error::ClientError
        attr_reader :response

        def initialize(response)
          super "too many redirects; last one to: #{response['location']}"
          @response = response
        end
      end

      class RedirectWithoutLocation < Faraday::Error::ClientError
        attr_reader :response

        def initialize(response)
          super "redirect without setting HTTP Location header"
          @response = response
        end
      end

      class FollowRedirects < Faraday::Middleware
        REDIRECTS    = [301, 302, 303]
        FOLLOW_LIMIT = 5

        def initialize(app, options = {})
          super(app)
          @options = options
          @limit   = options[:limit] || FOLLOW_LIMIT
        end

        def call(env)
          process(@app.call(env), @limit)
        end

        def process(response, limit)
          response.on_complete do |env|
            if redirect?(response)
              raise RedirectLimitReached, response if limit.zero?
              raise RedirectWithoutLocation, response if response['location'].blank?
              env[:url] += response['location']
              env[:method] = :get
              response = process(@app.call(env), limit - 1)
            end
          end
        end

        def redirect?(response)
          REDIRECTS.include? response.status
        end
      end
    end
  end
end

