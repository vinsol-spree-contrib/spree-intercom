Spree::TaxonsController.class_eval do

  after_action :create_product_filter_event_on_intercom, only: :show, if: :spree_current_user

  private

    def create_product_filter_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("#{controller_name}*#{action_name}", data)
    end

    def data
      {
        filter: @searcher.search.to_s,
        taxon: params[:id],
        time: Time.current.to_i,
        user_id: spree_current_user.id
      }
    end

end
