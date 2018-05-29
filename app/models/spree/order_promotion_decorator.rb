Spree::OrderPromotion.class_eval do

  after_commit :create_promotion_applied_event_on_intercom, on: :create, if: :user_present?
  after_commit :create_promotion_removed_event_on_intercom, on: :destroy, if: :user_present?

  private

    def create_promotion_applied_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("order_promotion*create", data)
    end

    def create_promotion_removed_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("order_promotion*destroy", data)
    end

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

end
