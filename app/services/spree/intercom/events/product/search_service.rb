class Spree::Intercom::Events::Product::SearchService < Spree::Intercom::BaseService

  EVENT_NAME = 'searched-product'

  def initialize(options)
    @taxon = Spree::Taxon.find_by(id: options[:taxon_id])
    @user = Spree::User.find_by(id: options[:user_id])
    @time = options[:time]
    @keyword = options[:keyword]
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
        keyword: @keyword || 'No keyword present',
        taxon: @taxon.try(:name) || 'No taxon present',
        filter: @filter.presence || 'No filter present'
      }
    }
  end

end
