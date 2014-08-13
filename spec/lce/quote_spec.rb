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
    context "with invalid parameters" do
      it "raises an error on an empty quote" do
      
        stub_request(:post, "https://login:password@test.lce.io/v1/quotes")
          .with(:body => '{"quote":{}}')
          .to_return(fixture('quotes/request/empty_quote'))
          
        expect{ Lce::Quote.request({})}.to raise_error(Lce::Client::Errors::LceError)
      end

      it "raises an error with missing params" do
        
        params = {
          shipper: {country: 'FR', postal_code: '31300', city: 'Toulouse'},
          recipient: {country: 'FR', postal_code: '06000', is_a_company: true},
          parcels: [{length: 15, width: 15, height: 15, weight: 2}]
        }
        
        stub_request(:post, "https://login:password@test.lce.io/v1/quotes")
          .with(:body => {quote: params})
          .to_return(fixture('quotes/request/missing_params'))
          
        expect{ Lce::Quote.request(params)}.to raise_error(Lce::Client::Errors::LceError, 'quote[recipient][city] is missing')
      end
    end  
    context "with valid parameters" do
      let(:params) {
        {
          shipper: {country: 'FR', postal_code: '31300', city: 'Toulouse'},
          recipient: {country: 'FR', postal_code: '06000', city: 'Nice',is_a_company: true},
          parcels: [{length: 15, width: 15, height: 15, weight: 2}]
        }
      }
      it "creates a quote" do
        stub_request(:post, "https://login:password@test.lce.io/v1/quotes")
          .with(:body => {quote: params})
          .to_return(fixture('quotes/request/created'))
        expect(Lce::Quote.request(params)).to be_a(Lce::Quote)
      end
    end    
  end
  describe ".find" do 
    let(:id) {'cd8d1a03-bfec-4115-87ef-8f8ba91a7199'}
    it 'returns a quote' do
      stub_request(:get, "https://login:password@test.lce.io/v1/quotes/#{id}")
        .to_return(fixture('quotes/request/found'))
      expect(Lce::Quote.find(id).id).to eql(id)    
    end
    context 'inexistant quote' do 
      let(:id) {'cd8d1a03-bfec-4115-87ef-8f8ba91a7198'}
      it 'returns a quote' do
        stub_request(:get, "https://login:password@test.lce.io/v1/quotes/#{id}")
          .to_return(fixture('quotes/request/not_found'))
        expect{Lce::Quote.find(id).id}.to raise_error(Lce::Client::Errors::LceError, 'Quote not found')
      end    
    end
  end  
  describe ".all" do 
    before do 
      stub_request(:get, "https://login:password@test.lce.io/v1/quotes")
        .to_return(fixture('quotes/request/all'))            
    end
    it 'returns all quotes' do
      expect(Lce::Quote.all.size).to eql(25)    
    end
    
    it 'returns quote object' do
      expect(Lce::Quote.all.first).to be_a(Lce::Quote)    
    end
    
    it 'returns a paginated array' do
      expect(Lce::Quote.all).to be_a(PaginatedArray)
    end    
    it 'returns total count' do
      expect(Lce::Quote.all.total_count).to eql(29)
    end    
    it 'returns current_page' do
      expect(Lce::Quote.all.current_page).to eql(1)
    end    
    it 'returns page size' do
      expect(Lce::Quote.all.per_page).to eql(25)
    end    
    context 'with a second page' do
      before do 
        stub_request(:get, "https://login:password@test.lce.io/v1/quotes?page=2")
          .to_return(fixture('quotes/request/all_page2'))            
      end
      it 'returns all quotes' do
        expect(Lce::Quote.all(2).size).to eql(4)    
      end
      it 'returns total count' do
        expect(Lce::Quote.all(2).total_count).to eql(29)
      end    
      it 'returns current_page' do
        expect(Lce::Quote.all(2).current_page).to eql(2)
      end    
    end
  end    
end
