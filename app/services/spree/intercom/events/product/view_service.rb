class Spree::Intercom::Events::Product::ViewService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @product = Spree::Product::find_by(id: options[:product_id])
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
      event_name: 'viewed-product',
      created_at: @options[:time],
      user_id: @user.intercom_user_id,
      metadata: {
        product: @product.name
      }
    }
  end

end
