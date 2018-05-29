class Spree::Intercom::Events::Taxon::FilterService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @options = options
    # @taxon = options[:taxon]
    # @filter = options[:filter]
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
      event_name: 'filtered-product',
      created_at: @options[:time],
      user_id: @user.intercom_user_id,
      metadata: {
        taxon: @options[:taxon],
        filter: @options[:filter].presence || 'no filter applied'
      }
    }
  end

end
