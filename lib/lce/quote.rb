require 'hashie'
module Lce
  class Quote < Hashie::Mash
    include Hashie::Extensions::Coercion
  
    coerce_key :offers, Array[Lce::Offer]
  
    class << self
      def request(params)
        response = Lce.client.post('quotes', {quote: params})
        new(response)
      end
      
      def all(page = 1)
        page = 1 if page <= 0
        response = Lce.client.get('quotes', nil, nil, nil , {page: page})
        response.map do |q|
          new(q)
        end        
      end

      def find(id)
        response = Lce.client.get('quotes', id)
        new(response)
      end
      
    end
  end
end
