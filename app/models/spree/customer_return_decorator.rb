Spree::CustomerReturn.class_eval do

  include Spree::ModelEventTracker

  after_commit :create_event_on_intercom, on: :create, if: :user_present?

  private

    def user_present?
      order.user_id.present?
    end

    def create_data
      {
        customer_return_id: id,
        order_id: order_id,
        user_id: order.user_id
      }
    end

end
