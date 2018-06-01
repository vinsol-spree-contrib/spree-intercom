class Spree::Intercom::Events::Customer::ReturnService < Spree::Intercom::BaseService

  EVENT_NAME = 'returned-order'

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @order = Spree::Order.find_by(id: options[:order_id])
    @return = Spree::CustomerReturn.find_by(id: options[:customer_return_id])
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
      created_at: @return.created_at,
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: @order.number,
        return_number: @return.number
      }
    }
  end

end
