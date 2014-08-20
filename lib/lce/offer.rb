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

    def available_delivery_locations(params)
      return [] unless product.preset_delivery_location == true
      Lce.client.get('offers', id, 'available_delivery_locations', nil , {location: params }).map! do |l|
        Hashie::Mash.new(l)
      end
    end
    
  end
end
