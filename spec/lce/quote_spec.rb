require 'spec_helper'

describe Lce::Quote do
  describe ".request" do
    it "requests a new quote" do
      expect(Lce::Quote.request({})).to be({})
    end
  end
end
