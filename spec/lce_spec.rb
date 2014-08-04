require 'spec_helper'

describe Lce do
  describe "#configure" do

    it 'has a configuration'  do
      expect(Lce.configuration).to be_a(Lce::Configuration)
    end
   
    it 'has a default environment'  do
      expect(Lce.configuration.environment).to be :staging
    end

    it 'raises an exception when an environment is not supported'  do
      expect { Lce.configuration.environment = :jungle }.to raise_error
    end

    it 'doesn\'t have a default login'  do
      expect(Lce.configuration.login).to be_nil
    end

    it 'doesn\'t have a default password'  do
      expect(Lce.configuration.password).to be_nil
    end

    context 'when configuration is overridden locally' do
      before do
        Lce.configure do |config|
          config.environment = :production
          config.login = 'login'
          config.password = 'password'
        end         
      end
      
      it 'can override default values'  do
        expect(Lce.configuration.environment).to be :production
      end

      it 'can set a login'  do
        expect(Lce.configuration.login).to eq('login')
      end
      
      it 'can set a password'  do
        expect(Lce.configuration.password).to eq('password')
      end
    end      
  end
end
