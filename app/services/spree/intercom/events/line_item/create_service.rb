class Spree::Intercom::Events::LineItem::CreateService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @line_item = Spree::LineItem.find_by(id: options[:line_item_id])
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
      event_name: 'added-product',
      created_at: @options[:time],
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: @line_item.order.number,
        product: @line_item.name,
        sku: @line_item.variant.sku,
        quantity: @line_item.quantity
      }
    }
  end

end
