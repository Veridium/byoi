class Api::EventsController < ApiController
  
    def index
      render :json => User.order(created_at: :DESC).to_json
    end

    def pay
      render :json => User.order(created_at: :DESC).to_json
    end

    def paid
      result = locations_api.list_locations()
      body = {}
      body[:source_id] = params[:nonce]
      body[:idempotency_key] = '4935a656-a929-4792-b97c-8848be85c27c'
      body[:amount_money] = {}
      body[:amount_money][:amount] = 200
      body[:amount_money][:currency] = 'USD'
      body[:autocomplete] = true
      body[:location_id] = 'XK3DBG77NJBFX'
      render :json => body.to_json
    end

    def locations
      client = Square::Client.new(access_token: 'EAAAEKTgbbWKzhUnGjlGTU1Fx5SkHfnCqiQ4omZk7-MAGtEW1kajqFa5uRXN6YkI',
        environment: "sandbox")
    
      # Call list_locations method to get all locations in this Square account
      result = client.locations.list_locations
    
      # Call the #success? method to see if the call succeeded
      if result.success?
        # The #data Struct contains a list of locations
        locations = result.data.locations
        render :json => locations.to_json
      else
        render :json => result.to_json, status: 422
      end
    end

    def order
      client = Square::Client.new(access_token: 'EAAAEKTgbbWKzhUnGjlGTU1Fx5SkHfnCqiQ4omZk7-MAGtEW1kajqFa5uRXN6YkI',
        environment: "sandbox")
    
      # Call list_locations method to get all locations in this Square account
      result = client.locations.list_locations
    
      # Call the #success? method to see if the call succeeded
      if result.success?
        locationId = result.data.locations[0][:id]

        orderRequest = {}
        orderRequest[:idempotency_key] = SecureRandom.uuid
        orderRequest[:order] = {}
        orderRequest[:order][:line_items] = []
        item = {}
        item[:name] = "Cake"
        item[:quantity] = "1"
        item[:base_price_money] = {}
        item[:base_price_money][:amount] = 150
        item[:base_price_money][:currency] = "USD"
        orderRequest[:order][:line_items] << item
        
        orderResult = client.orders.create_order(location_id: locationId, body: orderRequest);

        render :json => orderResult.to_json
      else
        render :json => result.to_json, status: 422
      end
    end

    def payment
      client = Square::Client.new(access_token: 'EAAAEKTgbbWKzhUnGjlGTU1Fx5SkHfnCqiQ4omZk7-MAGtEW1kajqFa5uRXN6YkI',
        environment: "sandbox")
    
      # Call list_locations method to get all locations in this Square account
      result = client.locations.list_locations
    
      # Call the #success? method to see if the call succeeded
      if result.success?
        locationId = result.data.locations[0][:id]

        orderRequest = {}
        orderRequest[:idempotency_key] = SecureRandom.uuid
        orderRequest[:order] = {}
        orderRequest[:order][:line_items] = []
        item = {}
        item[:name] = "Cake"
        item[:quantity] = "1"
        item[:base_price_money] = {}
        item[:base_price_money][:amount] = 150
        item[:base_price_money][:currency] = "USD"
        orderRequest[:order][:line_items] << item
        
        orderResult = client.orders.create_order(location_id: locationId, body: orderRequest);

        paymentRequest = {}
        paymentRequest[:source_id] = params[:nonce]
        paymentRequest[:idempotency_key] = SecureRandom.uuid
        paymentRequest[:amount_money] = {}
        paymentRequest[:amount_money][:amount] = 150
        paymentRequest[:amount_money][:currency] = 'USD'
        paymentRequest[:autocomplete] = true
        paymentRequest[:location_id] = locationId
        paymentRequest[:order_id] = orderResult.body.order[:id]

        paymentResult = client.payments.create_payment(body: paymentRequest)

        render :json => paymentResult.to_json
      else
        render :json => result.to_json, status: 422
      end
    end
  
  end