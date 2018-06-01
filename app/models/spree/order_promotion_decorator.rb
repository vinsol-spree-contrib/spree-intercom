Spree::OrderPromotion.class_eval do

  include Spree::EventTracker

  after_commit :create_event_on_intercom, on: :destroy, if: :user_present?

  private

    def user_present?
      order.user_id.present?
    end

    def destroy_data
      {
        order_id: order_id,
        promotion_id: promotion_id,
        time: Time.current.to_i,
        user_id: order.user_id
      }
    end

end
