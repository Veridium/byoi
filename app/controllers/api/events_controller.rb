class Api::EventsController < ApiController
  before_action :set_user_by_email, only: :reset
  before_action :set_user_with_confirmation, except: [:resend, :delete, :reset]
  before_action :set_user_without_confirmation, only: [:resend, :delete]

  def plans
    render :json => Plan.all.to_json
  end

  def confirm
    render :json => @user
  end

  def reset
    if @user.confirmed_at.nil?
      Devise::Mailer.confirmation_instructions(@user,@user.confirmation_token).deliver
    else
      @user.send_reset_password_instructions
    end
    render :json => @user
  end

  def delete
    @user.member.delete
    @user.delete
    render :json => @user
  end

  def resend
    if @user.confirmed_at.nil?
      Devise::Mailer.confirmation_instructions(@user,@user.confirmation_token).deliver
    end
    render :json => @user
  end

  def payment
    client = Square::Client.new(access_token: "EAAAEKTgbbWKzhUnGjlGTU1Fx5SkHfnCqiQ4omZk7-MAGtEW1kajqFa5uRXN6YkI",
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

      orderResult = client.orders.create_order(location_id: locationId, body: orderRequest)

      paymentRequest = {}
      paymentRequest[:source_id] = params[:nonce]
      paymentRequest[:idempotency_key] = SecureRandom.uuid
      paymentRequest[:amount_money] = {}
      paymentRequest[:amount_money][:amount] = 150
      paymentRequest[:amount_money][:currency] = "USD"
      paymentRequest[:autocomplete] = true
      paymentRequest[:location_id] = locationId
      paymentRequest[:order_id] = orderResult.body.order[:id]

      paymentResult = client.payments.create_payment(body: paymentRequest)

      render :json => paymentResult.to_json
    else
      render :json => result.to_json, status: 422
    end
  end

  private

    def set_user_by_email
      @user = User.find_by(email: params[:email])
      if @user.nil?
        render json: { "error":"Token failed verification (0)" }, status: 422 
      end
    end
    
    def set_user_with_confirmation
      @user = User.find_by(auth_token: params[:auth_token])
      if @user.nil?
        render json: { "error":"Token failed verification (1)" }, status: 422 
      elsif @user.confirmed_at.nil?
        render json: { "error":"Token failed verification (2)" }, status: 422 
      end
    end

    def set_user_without_confirmation
      @user = User.find_by(auth_token: params[:auth_token])
      if @user.nil?
        render json: { "error":"Token failed verification (3)" }, status: 422 
      elsif !@user.confirmed_at.nil?
        render json: { "error":"Token failed verification (4)" }, status: 422 
      end
    end

end
