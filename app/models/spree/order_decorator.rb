Spree::Order.class_eval do

  after_commit :create_order_state_change_event_on_intercom, on: :update, if: [:user_present?, :order_state_changed?, :order_not_placed?]
  after_commit :create_order_placed_event_on_intercom, on: :update, if: [:user_present?, :order_state_changed?, :complete?]
  # after_commit :create_order_shipped_event_on_intercom, on: :update, if: [:user_present?, :order_state_changed?, :shipped?]
  # after_commit :create_order_returned_event_on_intercom, on: :update, if: [:user_present?, :order_state_changed?, :returned?]

  private

    def create_order_state_change_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("order*update", data)
    end

    def create_order_placed_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("order*placed", data)
    end

    # def create_order_shipped_event_on_intercom
    #   Spree::Intercom::TrackEventsJob.perform_later("order*shipped", data)
    # end
    #
    # def create_order_returned_event_on_intercom
    #   Spree::Intercom::TrackEventsJob.perform_later("order*returned", data)
    # end

    def order_state_changed?
      saved_changes.include?(:state)
    end

    def order_not_placed?
      ['address', 'delivery', 'payment', 'confirm'].any? { |_state_| state == _state_ }
    end

    def data
      {
        user_id: user_id,
        order_id: id,
        previous_state: saved_changes[:state].first
      }
    end

    def user_present?
      user_id.present?
    end

end
