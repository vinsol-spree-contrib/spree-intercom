class Spree::Intercom::Events::Order::PlaceService < Spree::Intercom::BaseService

  EVENT_NAME = 'placed-order'

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
      event_name: EVENT_NAME,
      created_at: @order.updated_at,
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: {
          url: order_url,
          value: @order.number
        },
        price: {
          amount: @order.amount,
          currency: @order.currency
        }
      }
    }
  end

  private

    def order_url
      Spree::Core::Engine.routes.url_helpers.order_url(@order, host: host_name, protocol: protocol_name)
    end

    def host_name
      Rails.application.routes.default_url_options[:host].presence || "localhost:3000"
    end

    def protocol_name
      Rails.application.routes.default_url_options[:protocol].presence || "http"
    end

end
