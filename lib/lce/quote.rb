require 'hashie'
require 'paginated_array'

module Lce
  class Quote < Hashie::Mash
    include Hashie::Extensions::Coercion
  
    coerce_key :offers, Array[Lce::Offer]
  
    class << self
      def request(params)
        response = Lce.client.post('quotes', {quote: params})
        new(response)
      end
      
      def all(page = nil)
        if page
          page = 1 if page <= 0
          options = {page: page}
        end
        response = Lce.client.get('quotes', nil, nil, nil , options)
        response.map! do |q|
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
