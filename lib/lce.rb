require "lce/version"
require "lce/client"
require "logger"
require "awesome_print"

module Lce
  class << self
    attr_accessor :configuration
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
      Client.new.get
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
    attr_accessor :login, :password, :environment, :version, :http_adapter, :raise_lce_errors, :logger

    def initialize
      @environment = :staging
      @version = 1
      @http_adapter = Faraday.default_adapter
      @raise_lce_errors = true
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::DEBUG       
    end
    
    def environment=(value)
      raise 'Environment must be :staging or :production' unless [:staging, :production].include?(value)
      @environment = value
    end
  end
end

