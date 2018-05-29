class Spree::Intercom::Events::Order::PlaceService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @order = Spree::Order.find_by(id: options[:order_id])
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
      event_name: 'order-place',
      created_at: @order.updated_at,
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: @order.number,
        amount: @order.amount
      }
    }
  end

end
