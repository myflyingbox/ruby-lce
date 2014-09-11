require 'hashie'
require 'paginated_array'

module Lce
  class Product < Hashie::Mash
    include Hashie::Extensions::Coercion
   
    class << self     
      def all
        response = Lce.client.get('products', nil, nil, nil , nil)
        response.map! do |q|
          new(q)
        end        
      end      
    end
  end
end
