# Lce

A Ruby library that provides an interface to the LCE web services.

## Installation

This library is packaged as a gem. So you can add this line to your application's Gemfile:

    gem 'lce'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lce
    
## Configuration

You can configure this gem by using a configuration block :

    Lce.configure do |config|
      config.environment = :staging
      config.login = 'login'
      config.password = 'password'
    end

If you are using the gem in a Rails application, you can store this configuation with oher initializers in : 

    RAILS_ROOT/config/initializers/lce.rb
    
Here are all available configuration options with their default values : 

    Lce.configure do |config|
      # Switch to :production when you are ready to go live
      config.environment = :staging 

      # No default for authentication attributes. You should have received that by email if not ask us at support@lce.io
      config.login = 
      config.password =

      # You can set it to Rails.logger if you are using a rails app.
      config.logger = Logger.new(STDOUT)

      # You can set your own application's name and version.
      config.application = 'ruby-lce' 
      config.version = '0.0.1'
    end

## Usage

Once configured, you can start making request to the lce webservices. The full documentation for all requests and attributes is available at https://www.lce.io/docs

### Requesting a quote

    quote_params = {
      shipper: {city: "Toulouse", postal_code: "31000", country:"FR"},
      recipient: {city: "Nice", postal_code: "06000", country: "FR", is_a_company: false},
      parcels: [
        {length: 25,height: 25, width: 25, weight: 3}
      ]
    }
    quote = Lce::Quote.request(quuote_params)

### Placing an order

    order_params = {
      shipper: {name: "Firstname Lastname", street: "999, street name", phone: "+33699999999", email: "support@lce.io"},
      recipient: {name: "Firstname Lastname", street: "111, other street", phone: "+33600000", email: "support@lce.io"},
      parcels: [{description: 'Gift'}]

    }
    # First, we select an offer we want to order (for this example, we are using the first one)
    offer = quote.offers.first
    order = offer.place_order(order_params)

### Retrieving the labels

    # We can retrieve the labels
    labels = order.labels
    # and write them to our drive
    File.open("order-#{order.id}.pdf", "wb") do |f|
      f.write(labels)
    end  

### Getting the tracking informations
    
    # And then, we can get the trakcing events by parcels
    order.tracking

## Contributing

1. Fork it ( http://github.com/lce/ruby-lce/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
