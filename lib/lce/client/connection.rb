require 'faraday'
require 'faraday/mashify'
module Lce
  class Client
    module Connection
      private
        def connection
          Faraday.new(:url => host) do |faraday|
            faraday.request :authorization, :basic, Lce.configuration.login, Lce.configuration.password
            faraday.headers['Lce-Origin-Application'] = Lce.configuration.application
            faraday.headers['Lce-Origin-Version'] = Lce.configuration.version
            faraday.request :json
            faraday.response :mashify
            faraday.response :json, :content_type => /\bjson$/
            faraday.response :logger, Lce.configuration.logger
            faraday.adapter  http_adapter
          end
        end
    end
  end
end
