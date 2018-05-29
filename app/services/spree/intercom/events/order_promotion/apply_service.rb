class Spree::Intercom::Events::OrderPromotion::ApplyService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @order = Spree::Order.find_by(id: options[:order_id])
    @promotion = Spree::Promotion.find_by(id: options[:promotion_id])
    @options = options
    super()
  end

  def register
    send_request
  end

  def perform
    @intercom.events.create(event_data)
  end

  def event_data
    {
      event_name: 'applied-promotion',
      created_at: @options[:time],
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: @order.number,
        code: @promotion.code
      }
    }
  end

end
