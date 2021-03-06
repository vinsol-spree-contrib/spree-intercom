class Spree::Intercom::Events::Shipment::ShipService < Spree::Intercom::BaseService

  EVENT_NAME = 'shipped-order'

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @order = Spree::Order.find_by(id: options[:order_id])
    @shipment = Spree::Shipment.find_by(id: options[:shipment_id])
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
      created_at: @shipment.updated_at,
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: {
          url: order_url,
          value: @order.number
        },
        shipment_number: @shipment.number
      }
    }
  end

end
