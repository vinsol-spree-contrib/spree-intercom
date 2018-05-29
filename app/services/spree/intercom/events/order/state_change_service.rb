class Spree::Intercom::Events::Order::StateChangeService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @order = Spree::Order.find_by(id: options[:order_id])
    @previous_state = options[:previous_state]
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
      event_name: 'order-state-change',
      created_at: @order.updated_at,
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: @order.number,
        from: @previous_state ,
        to: @order.state
      }
    }
  end

end
