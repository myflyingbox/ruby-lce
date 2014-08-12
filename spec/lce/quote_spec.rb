require 'spec_helper'

describe Lce::Quote do
  before do
    Lce.configure do |config|
      config.environment = :staging
      config.login = 'login'
      config.password = 'password'
      config.logger.level = Logger::FATAL
    end              
  end
  describe ".request" do
    it "raises an error on an empty quote" do
    
      stub_request(:post, "https://login:password@test.lce.io/v1/quotes")
        .with(:body => '{"quote":{}}')
        .to_return(fixture('quotes/request/empty_quote'))
        
      expect{ Lce::Quote.request({})}.to raise_error(Lce::Client::Errors::LceError)
    end
    
  end
end
