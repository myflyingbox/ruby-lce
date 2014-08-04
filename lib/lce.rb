require "lce/version"

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

  class Configuration
    attr_accessor :login, :password, :environment

    def initialize
      @environment = :staging
    end
    
    def environment=(value)
      raise 'Environment must be :staging or :production' unless [:staging, :production].include?(value)
      @environment = value
    end
  end
end

