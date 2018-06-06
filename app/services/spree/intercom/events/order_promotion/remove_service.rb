class Spree::Intercom::Events::OrderPromotion::RemoveService < Spree::Intercom::BaseService

  EVENT_NAME = 'removed-promotion'

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @order = Spree::Order.find_by(id: options[:order_id])
    @promotion = Spree::Promotion.find_by(id: options[:promotion_id])
    @time = options[:time]
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
      event_name: EVENT_NAME,
      created_at: @time,
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: @order.number,
        code: @promotion.code
      }
    }
  end

end
