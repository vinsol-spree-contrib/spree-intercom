Spree::Shipment.class_eval do

  include Spree::EventTracker

  state_machine.after_transition to: :shipped, do: :create_event_on_intercom, if: :user_present?

  private

    def user_present?
      order.user_id.present?
    end

    def update_data
      {
        order_id: order_id,
        shipment_id: id,
        user_id: order.user_id
      }
    end

end
