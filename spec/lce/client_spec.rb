require 'spec_helper'

describe Lce::Client do
  describe "#http_adapter" do
    it "uses default faraday's adapter as a default" do
      expect(subject.http_adapter).to be(Faraday.default_adapter)

    end
  end
  describe "#host" do
    it 'returns the correct host for the staging environment' do
      expect(subject.host).to eql('https://test.lce.io')
    end

    it 'returns the correct host for the production environment' do
      Lce.configuration.environment = :production
      expect(subject.host).to eql('https://api.lce.io')
    end
  end
  describe "#api version" do
    it 'returns a string of the API version' do
      expect(subject.api_version).to eql('v1')
    end
    it 'needs a valid version' do
      Lce.configuration.api_version = 'api_version'      
      expect { subject.api_version }.to raise_error(Lce::Client::Errors::VersionError)
    end    
  end  
  describe "#path" do
    it 'returns a root path as default' do
      expect(subject.send(:path).to_s).to eql('/')
    end
    context 'with a resource' do
      it 'returns a path with aversion and a resource' do
        Lce.configuration.api_version = 1
        expect(subject.send(:path, :quotes).to_s).to eql('/v1/quotes')
      end

    end
  end    
end
