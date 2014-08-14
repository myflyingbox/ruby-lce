require 'spec_helper'

describe Lce::Offer do
  before do
    Lce.configure do |config|
      config.environment = :staging
      config.login = 'login'
      config.password = 'password'
      config.logger.level = Logger::FATAL
    end              
  end
  describe ".find" do 
    let(:id) {'ff75b691-a2e0-46b0-9909-d529b2dbb90c'}
    it 'returns an offer' do
      stub_request(:get, "https://login:password@test.lce.io/v1/offers/#{id}")
        .to_return(fixture('offers/find/found'))
      expect(Lce::Offer.find(id).id).to eql(id)    
    end
    context 'inexistant offer' do 
      let(:id) {'ff75b691-a2e0-46b0-9909-d529b2dbb90d'}
      it 'raise an exception' do
        stub_request(:get, "https://login:password@test.lce.io/v1/offers/#{id}")
          .to_return(fixture('offers/find/not_found'))
        expect{Lce::Offer.find(id).id}.to raise_error(Lce::Client::Errors::LceError, 'Offer not found')
      end    
    end
  end    
end
