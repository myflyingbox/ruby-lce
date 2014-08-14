require 'hashie'
module Lce
  class Offer < Hashie::Mash
    class << self
      def find(id)
        response = Lce.client.get('offers', id)
        new(response)
      end
      
    end
  end
end
