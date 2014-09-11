require "lce/version"
require "lce/client"
require "lce/product"
require "lce/offer"
require "lce/quote"
require "lce/order"
require "logger"
require "awesome_print"

module Lce
  class << self
    attr_accessor :configuration, :client
  end

  def self.client
    @client ||= Client.new
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.check
    begin  
      client.get
    rescue Lce::Client::Errors::LceError => e
      if configuration.raise_lce_errors
        raise e      
      else
        configuration.logger.warn(e.to_s)
      end
      return false
    end
  end


  class Configuration
    attr_accessor :login, :password, :environment, :api_version, :http_adapter, :raise_lce_errors, :logger, :application, :version

    def initialize
      @environment = :staging
      @api_version = 1
      @http_adapter = Faraday.default_adapter
      @raise_lce_errors = true
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::DEBUG   
      @application = 'ruby-lce'    
      @version = Lce::VERSION
    end
    
    def environment=(value)
      raise 'Environment must be :staging or :production' unless [:staging, :production].include?(value)
      @environment = value
    end
    
    def application=(app)
      @application = "#{app} (ruby-lce)"
    end

    def version=(version)
      @version = "#{version} (#{Lce::VERSION})"
    end
  end
end

