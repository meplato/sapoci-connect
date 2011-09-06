module SAPOCI
  module Connect
    module Middleware
      class BackgroundSearch < Faraday::Response::Middleware
        def initialize(app, options = {})
          @options = options
          super(app)
        end

        def call(env)
          @app.call(env).on_complete do |resp|
            case env[:status]
            when 200
              env[:sapoci] = SAPOCI::Document.from_html(env[:body])
            else
            end
          end
        end
      end
    end
  end
end
