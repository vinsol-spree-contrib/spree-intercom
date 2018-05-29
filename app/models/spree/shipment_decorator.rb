Spree::Shipment.class_eval do

  state_machine.after_transition to: :shipped, do: :create_order_shipped_event_on_intercom, if: :user_present?

  private

    def create_order_shipped_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("shipment*update", data)
    end

    def user_present?
      order.user_id.present?
    end

    def data
      {
        order_id: order_id,
        shipment_id: id,
        user_id: order.user_id
      }
    end

end
