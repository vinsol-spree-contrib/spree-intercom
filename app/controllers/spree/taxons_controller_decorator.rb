Spree::TaxonsController.class_eval do

  after_action :create_product_filter_event_on_intercom, only: :show, if: :spree_current_user

  private

    def create_product_filter_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("#{controller_name}*#{action_name}", data)
    end

    def data
      {
        user_id: spree_current_user.id,
        taxon: params[:id],
        filter: @searcher.search.to_s
      }
    end

end
