require 'spec_helper'

describe Lce do
  describe ".configure" do
   
    it 'has a configuration' do
      Lce.reset
      expect(Lce.configuration).to be_a(Lce::Configuration)
    end
   
    it 'has a default environment' do
      Lce.reset
      expect(Lce.configuration.environment).to be :staging
    end

    it 'raises an exception when an environment is not supported'  do
      expect { Lce.configuration.environment = :jungle }.to raise_error
    end

    it 'doesn\'t have a default login'do
      Lce.reset
      expect(Lce.configuration.login).to be_nil
    end

    it 'has a default application name' do
      Lce.reset
      expect(Lce.configuration.application).to eql 'ruby-lce'
    end

    it 'uses the gem\'s version as its default' do
      Lce.reset
      expect(Lce.configuration.version).to be Lce::VERSION
    end

    
    it 'doesn\'t have a default password' do
      Lce.reset    
      expect(Lce.configuration.password).to be_nil
    end

    context 'when configuration is overridden locally' do
      before do
        Lce.configure do |config|
          config.environment = :production
          config.login = 'login'
          config.password = 'password'
          config.application = 'My Great App'
          config.version = 'E.32.R526'          
        end         
      end
      
      it 'can override default values' do
        expect(Lce.configuration.environment).to be :production
      end

      it 'can set a login' do
        expect(Lce.configuration.login).to eq('login')
      end
      
      it 'can set a password' do
        expect(Lce.configuration.password).to eq('password')
      end

      it 'customizes app name but retains the gem\'s name' do
        expect(Lce.configuration.application).to eq("My Great App (ruby-lce)")
      end      

      it 'customizes app version but retains the gem\'s version' do
        expect(Lce.configuration.version).to eq("E.32.R526 (#{Lce::VERSION})")
      end      

    end      
  end
  describe '.check' do 
    context 'without authentication' do
      before do
        Lce.configure do |config|
          config.environment = :staging
          config.login = nil
          config.password = nil
          config.logger.level = Logger::FATAL
        end             
      end
      it 'raises an AccessDenied exception when not authenticated properly' do
        stub_request(:get, "https://test.lce.io/").to_return(fixture('access_denied'))
        expect {Lce.check}.to raise_error Lce::Client::Errors::AccessDenied
      end
    end
    context 'with authentication' do
      before do
        Lce.configure do |config|
          config.environment = :staging
          config.login = 'login'
          config.password = 'password'
          config.logger.level = Logger::FATAL
        end              
      end
      it 'raises an AccountDisabled exception when account is disabled' do
        stub_request(:get, "https://login:password@test.lce.io/").to_return(fixture('account_disabled'))
        expect {Lce.check}.to raise_error Lce::Client::Errors::AccountDisabled
      end    
      it 'return a description of the service' do    
        stub_request(:get, "https://login:password@test.lce.io/").to_return(fixture('check'))
        expect(Lce.check.host).to eql('test.lce.io')
      end    
    end    

  end
end
