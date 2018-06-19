require 'lce/client/connection'
require 'lce/client/errors'
require 'lce/client/request'

module Lce
  class Client

    HOSTS = {
      development: "http://localhost:9000",
      staging: "https://test.myflyingbox.com",
      production: "https://api.myflyingbox.com"
    }

    include Connection
    include Request
    include Errors

    attr_accessor :http_adapter

    def initialize
      @http_adapter = Lce.configuration.http_adapter
    end

    def host
      HOSTS[Lce.configuration.environment]
    end

    def api_version
      raise VersionError.new("Wrong API version",' wrong_api_version', "Version must be 1 or 2.") unless [1, 2].include?(Lce.configuration.api_version)
      'v'+Lce.configuration.api_version.to_s
    end

  end
end
