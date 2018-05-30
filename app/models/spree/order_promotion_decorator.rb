Spree::OrderPromotion.class_eval do

  include Spree::ModelEventTracker

  after_commit :create_event_on_intercom, on: [:create, :destroy], if: :user_present?

  private

    def user_present?
      order.user_id.present?
    end

    def data
      {
        order_id: order_id,
        promotion_id: promotion_id,
        time: Time.current.to_i,
        user_id: order.user_id
      }
    end

    def create_data
      data
    end

    def destroy_data
      data
    end

end
