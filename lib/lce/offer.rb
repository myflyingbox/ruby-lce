require 'hashie'
module Lce
  class Offer < Hashie::Mash
    class << self
      def find(id)
        response = Lce.client.get('offers', id)
        new(response)
      end
      
    end
    
    def place_order(params)
      params.merge!(offer_id: id)
      Order.place(params)    
    end
    
  end
end
