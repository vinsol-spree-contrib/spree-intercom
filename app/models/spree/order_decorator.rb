Spree::Order.class_eval do

  include Spree::EventTracker

  INTERCOM_ORDER_STATES = [:cart, :address, :delivery, :payment, :confirm, :complete]

  state_machine.after_transition to: INTERCOM_ORDER_STATES, do: :create_event_on_intercom, if: :user_present?

  private

    def set_data
      {
        order_id: id,
        user_id: user_id
      }
    end

    def update_data
      set_data
    end

    def placed_data
      set_data
    end

    def user_present?
      user_id.present?
    end

end
