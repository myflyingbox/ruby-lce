require 'hashie'
require 'paginated_array'

module Lce
  class Order < Hashie::Mash
    include Hashie::Extensions::Coercion
       
    coerce_key :quote, Lce::Quote
  
    class << self
      def place(params)
        response = Lce.client.post('orders', {order: params})
        new(response)
      end
      
      def all(page = nil)
        if page
          page = 1 if page <= 0
          options = {page: page}
        end
        response = Lce.client.get('orders', nil, nil, nil , options)
        response.map! do |q|
          new(q)
        end        
      end

      def find(id)
        response = Lce.client.get('orders', id)
        new(response)
      end
      
    end

    def labels
      @labels ||= Lce.client.get('orders', id, 'labels', 'pdf')      
    end    

    def write_labels(name = nil)    
      name = (name.is_a?(String)) ? name : "labels-#{id}.pdf"
      File.open(name, "wb") do |f|
        f.write(labels)
      end   
    end  
  end
end
