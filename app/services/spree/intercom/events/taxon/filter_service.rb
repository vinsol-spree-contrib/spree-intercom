class Spree::Intercom::Events::Taxon::FilterService < Spree::Intercom::BaseService

  EVENT_NAME = 'filtered-product'

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @time = options[:time]
    @taxon = options[:taxon]
    @filter = options[:filter]
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
        taxon: @taxon,
        filter: @filter.presence || 'no filter applied'
      }
    }
  end

end
