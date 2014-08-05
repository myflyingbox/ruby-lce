require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/parse_oj'

module Lce
  class Client
    module Connection
      private
        def connection
          Faraday.new(:url => host) do |faraday|
            faraday.basic_auth(Lce.configuration.login, Lce.configuration.password)
            faraday.request :json
            faraday.response :mashify               
            faraday.response :oj, :content_type => /\bjson$/                           
            faraday.response :logger, Lce.configuration.logger
            faraday.adapter  http_adapter
          end        
        end
    end
  end
end
