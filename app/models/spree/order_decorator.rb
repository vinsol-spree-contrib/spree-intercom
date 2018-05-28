Spree::Order.class_eval do

  after_commit :create_order_state_change_event_on_intercom, on: :update, if: :order_state_changed?

  private

    def create_order_state_change_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("order*update", data)
    end

    def order_state_changed?
      saved_changes.include?(:state)
    end

end
