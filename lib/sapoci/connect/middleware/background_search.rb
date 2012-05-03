module SAPOCI
  module Connect
    module Middleware
      class BackgroundSearch < Faraday::Response::Middleware
        def on_complete(env)
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
