class Api::EventsController < ApiController
  before_action :set_user_by_email, only: :reset
  before_action :set_user_with_confirmation, except: [:resend, :delete, :reset]
  before_action :set_user_without_confirmation, only: [:resend, :delete]

  def plans
    render :json => Plan.all.to_json
  end

  def plan
    render :json => Plan.find_by_name(params[:planName])
  end

  def invoice
    plan = Plan.find(params[:plan_id])
    discount = Discount.where(:name => params[:coupon], :plan => plan).first
    rebate = plan.price * ((discount.nil? ? 0 : discount.percentage) / 100.0)
    total = plan.price - rebate
    invoice = Invoice.new(user:@user,plan:plan,discount:discount,rebate:rebate,total:total)
    invoice.save!
    render :json => invoice, :include => {:plan => {:only => [:name,:price_cents]}, :discount => {:only => [:name,:percentage]}}
  end

  def confirm
    render :json => @user
  end

  def reset
    if @user.confirmed_at.nil?
      Devise::Mailer.confirmation_instructions(@user,@user.confirmation_token).deliver
      render :json => { "message": "resent confirmation" }, status: 201
    else
      @user.send_reset_password_instructions
      render :json => { "message": "reset code sent" }
    end
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
    client = Square::Client.new(access_token: ENV['SQUARE_TOKEN'],
                                environment: ENV['SQUARE_ENVIRONMENT'])

    # Call list_locations method to get all locations in this Square account
    result = client.locations.list_locations

    # Call the #success? method to see if the call succeeded
    if result.success?
      locationId = result.data.locations[0][:id]

      invoice = Invoice.find(params[:invoice_id]);

      orderRequest = {}
      orderRequest[:idempotency_key] = SecureRandom.uuid
      orderRequest[:order] = {}
      orderRequest[:order][:line_items] = []
      item = {}
      item[:name] = invoice.plan.name
      item[:quantity] = "1"
      item[:base_price_money] = {}
      item[:base_price_money][:amount] = invoice.total_cents
      item[:base_price_money][:currency] = "USD"
      orderRequest[:order][:line_items] << item

      orderResult = client.orders.create_order(location_id: locationId, body: orderRequest)

      paymentRequest = {}
      paymentRequest[:source_id] = params[:nonce]
      paymentRequest[:idempotency_key] = SecureRandom.uuid
      paymentRequest[:amount_money] = {}
      paymentRequest[:amount_money][:amount] = invoice.total_cents
      paymentRequest[:amount_money][:currency] = "USD"
      paymentRequest[:autocomplete] = true
      paymentRequest[:location_id] = locationId
      paymentRequest[:order_id] = orderResult.body.order[:id]

      paymentResult = client.payments.create_payment(body: paymentRequest)
      expires = nil
      if !invoice.plan.duration.nil?
        expires = Time.at(DateTime.now.to_i + invoice.plan.duration).to_datetime
      end

      purchase = Purchase.new(
        user: @user,
        invoice: invoice,
        plan: invoice.plan,
        expires: expires,
        order_id: paymentResult.body.payment[:order_id],
        payment_id: paymentResult.body.payment[:id],
        cardbrand: paymentResult.body.payment[:card_details][:card][:card_brand],
        lastfour: paymentResult.body.payment[:card_details][:card][:last_4],
        fingerprint: paymentResult.body.payment[:card_details][:card][:fingerprint],
        description: paymentResult.body.payment[:card_details][:statement_description],
        amount_cents: paymentResult.body.payment[:total_money][:amount],
        currency: paymentResult.body.payment[:total_money][:currency]
      )
      purchase.save!
      EventMailer.with(user: @user, purchase: purchase).receipt_email.deliver

      render :json => purchase, :include => {:user => {:only => [:email]}, :plan => {:only => [:name]}}
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
