Spree::ProductsController.class_eval do

  after_action :create_product_view_event_on_intercom, only: :show, if: :spree_current_user
  after_action :create_product_search_event_on_intercom, only: :index, if: [:spree_current_user, :searched?]

  private

    def create_product_view_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("#{controller_name}*#{action_name}", data)
    end

    def create_product_search_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("#{controller_name}*#{action_name}", search_data)
    end

    def data
      {
        product_id: @product.id,
        time: Time.current.to_i,
        user_id: spree_current_user.id
      }
    end

    def search_data
      {
        search_keyword: params[:keywords],
        time: Time.current.to_i,
        user_id: spree_current_user.id
      }
    end

    def searched?
      params[:keywords].present?
    end

end
