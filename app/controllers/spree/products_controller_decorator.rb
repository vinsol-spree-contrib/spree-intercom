Spree::ProductsController.class_eval do

  include Spree::ControllerEventTracker

  after_action :create_event_on_intercom, only: [:show, :index]

  private

    def show_data
      {
        product_id: @product.id,
        time: Time.current.to_i,
        user_id: spree_current_user.id
      }
    end

    def index_data
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
