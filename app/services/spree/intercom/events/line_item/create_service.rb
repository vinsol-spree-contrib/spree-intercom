class Spree::Intercom::Events::LineItem::CreateService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @line_item = Spree::LineItem.find_by(id: options[:line_item_id])
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
      event_name: 'add-product',
      created_at: @line_item.created_at.to_i,
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: @line_item.order.number,
        product: @line_item.name,
        quantity: @line_item.quantity
      }
    }
  end

end
