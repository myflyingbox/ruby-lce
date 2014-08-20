require 'spec_helper'

describe Lce::Order do
  before do
    Lce.configure do |config|
      config.environment = :staging
      config.login = 'login'
      config.password = 'password'
      config.logger.level = Logger::FATAL
    end              
  end

  describe '.place' do 
    context "with invalid parameters" do    
      it "raises an error on an empty order" do
        stub_request(:post, "https://login:password@test.lce.io/v1/orders")
          .with(:body => '{"order":{}}')
          .to_return(fixture('orders/place/empty_params'))
          
        expect{ Lce::Order.place({})}.to raise_error(Lce::Client::Errors::LceError)
      end

      it "raises an error with missing params" do
        params = {
          shipper: {name: "Firstname Lastname", street: "street", phone: "+33699999999", email: "support@lce.io"},
          recipient: {name: "Firstname Lastname", street: "street", phone: "+33699999999", email: "support@lce.io"},
          parcels: []
        }      
      
        stub_request(:post, "https://login:password@test.lce.io/v1/orders")
          .with(:body => {order: params})
          .to_return(fixture('orders/place/missing_params'))
          
        expect{ Lce::Order.place(params)}.to raise_error(Lce::Client::Errors::LceError, 'order[offer_id] is missing')
      end
    end
    context "with valid parameters" do
      let(:params) {
        {
          offer_id: "ff75b691-a2e0-46b0-9909-d529b2dbb90c",
          shipper: {name: "Firstname Lastname", street: "street", phone: "+33699999999", email: "support@lce.io"},
          recipient: {name: "Firstname Lastname", street: "street", phone: "+33699999999", email: "support@lce.io"},
          parcels: []
        }
      }
      it "creates an order" do
        stub_request(:post, "https://login:password@test.lce.io/v1/orders")
          .with(:body => {order: params})
          .to_return(fixture('orders/place/created'))
        expect(Lce::Order.place(params)).to be_a(Lce::Order)
      end
    end               
  end
  
  describe ".find" do 
    let(:id) {'8c43a2e1-a7ff-49fd-807e-3877d6dadc28'}
    it 'returns an order' do
      stub_request(:get, "https://login:password@test.lce.io/v1/orders/#{id}")
        .to_return(fixture('orders/find/found'))
      expect(Lce::Order.find(id).id).to eql(id)    
    end
    context 'inexistant order' do 
      let(:id) {'8c43a2e1-a7ff-49fd-807e-3877d6dadc29'}
      it 'raises an error' do
        stub_request(:get, "https://login:password@test.lce.io/v1/orders/#{id}")
          .to_return(fixture('orders/find/not_found'))
        expect{Lce::Order.find(id).id}.to raise_error(Lce::Client::Errors::LceError, 'Order not found')
      end    
    end
  end  
  describe ".all" do 
    before do 
      stub_request(:get, "https://login:password@test.lce.io/v1/orders")
        .to_return(fixture('orders/all/page_1'))            
    end
    it 'returns all orders' do
      expect(Lce::Order.all.size).to eql(1)    
    end
    
    it 'returns order object' do
      expect(Lce::Order.all.first).to be_a(Lce::Order)    
    end
    
    it 'returns a paginated array' do
      expect(Lce::Order.all).to be_a(PaginatedArray)
    end    
    it 'returns total count' do
      expect(Lce::Order.all.total_count).to eql(1)
    end    
    it 'returns current_page' do
      expect(Lce::Order.all.current_page).to eql(1)
    end    
    it 'returns page size' do
      expect(Lce::Order.all.per_page).to eql(25)
    end    

  end 
  
  describe "#labels" do 
    let(:id) {'8c43a2e1-a7ff-49fd-807e-3877d6dadc28'}
    it 'returns the labels for this order' do
      stub_request(:get, "https://login:password@test.lce.io/v1/orders/#{id}")
        .to_return(fixture('orders/find/found'))
      stub_request(:get, "https://login:password@test.lce.io/v1/orders/#{id}/labels.pdf")
        .to_return(fixture('orders/labels/response'))                
        
      order = Lce::Order.find(id)
      labels_file = File.read('spec/fixtures/orders/labels/labels.pdf', {mode: 'rb' })
      expect(order.labels).to eql(labels_file)
    end      
  end    

  describe "#tracking" do 
    let(:id) {'8c43a2e1-a7ff-49fd-807e-3877d6dadc28'}
    it 'returns the tracking for this order' do
      stub_request(:get, "https://login:password@test.lce.io/v1/orders/#{id}")
        .to_return(fixture('orders/find/found'))
      stub_request(:get, "https://login:password@test.lce.io/v1/orders/#{id}/tracking")
        .to_return(fixture('orders/tracking'))                       
        
      tracking_events_by_parcel = [{
        "parcel_index"=>0,
        "events"=> [{
          "code"=>"shipment_created",
          "happened_at"=>"2014-08-19T16:41:00+02:00",
          "label"=>{"fr"=>"Expédition créée", "en"=>"Shipment created"},
          "location"=>{"name"=>"Web Services"}
        }]
      }]      
                  
      order = Lce::Order.find(id)
      expect(order.tracking).to eql(tracking_events_by_parcel)
    end      
  end  
    
end
