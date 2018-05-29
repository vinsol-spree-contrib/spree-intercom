class Spree::Intercom::Events::LineItem::RemoveService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
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
      event_name: 'removed-product',
      created_at: @options[:time],
      user_id: @user.intercom_user_id,
      metadata: {
        order_number: @options[:order_number],
        product: @options[:name],
        sku: @options[:sku]
      }
    }
  end

end
