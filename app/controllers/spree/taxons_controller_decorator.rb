Spree::TaxonsController.class_eval do

  include Spree::ControllerEventTracker

  after_action :create_event_on_intercom, only: :show

  private

    def show_data
      {
        filter: @searcher.search.to_s,
        taxon: params[:id],
        time: Time.current.to_i,
        user_id: spree_current_user.id
      }
    end

end
