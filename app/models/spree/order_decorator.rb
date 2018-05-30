Spree::Order.class_eval do

  TRACKED_STATES = [:cart, :address, :delivery, :payment, :confirm]

  state_machine.after_transition to: TRACKED_STATES, do: :create_order_state_change_event_on_intercom, if: :user_present?
  state_machine.after_transition to: :complete, do: :create_order_placed_event_on_intercom, if: :user_present?

  private

    def create_order_state_change_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("order*update", data)
    end

    def create_order_placed_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("order*placed", data)
    end

    def data
      {
        order_id: id,
        user_id: user_id
      }
    end

    def user_present?
      user_id.present?
    end

end
