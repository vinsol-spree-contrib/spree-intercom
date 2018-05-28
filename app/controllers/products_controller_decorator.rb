Spree::ProductsController.class_eval do

  after_action :create_product_view_event_on_intercom, only: :show, if: :spree_current_user

  private

    def create_product_view_event_on_intercom
      Spree::Intercom::Events::ProductViewJob.perform_later(spree_current_user.id, @product.id)
    end

end
