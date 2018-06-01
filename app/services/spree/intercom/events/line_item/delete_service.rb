class Spree::Intercom::Events::LineItem::DeleteService < Spree::Intercom::BaseService

  EVENT_NAME = 'removed-product'

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @time = options[:time]
    @order_number = options[:order_number]
    @sku = options[:sku]
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
        order_number: @order_number,
        product: @name,
        sku: @sku
      }
    }
  end

end
