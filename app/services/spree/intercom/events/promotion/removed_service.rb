class Spree::Intercom::Events::Promotion::RemovedService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @order = Spree::Order.find_by(id: options[:order_id])
    @promotion = Spree::Promotion.find_by(id: options[:promotion_id])
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
      event_name: 'promotion-removed',
      created_at: Time.current.to_i,
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: @order.number,
        promotion: @promotion.code
      }
    }
  end

end
