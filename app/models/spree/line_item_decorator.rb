Spree::LineItem.class_eval do

  after_commit :create_line_item_added_event_on_intercom, on: :create, if: :user_present?
  after_commit :create_line_item_updated_event_on_intercom, on: :update, if: [:user_present?, :quantity_updated_to_non_zero_quantity?]
  after_commit :create_line_item_removed_event_on_intercom, on: :destroy, if: :user_present?

  private

    def user_present?
      order.user_id.present?
    end

    def create_line_item_added_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("line_items*create", data)
    end

    def create_line_item_updated_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("line_items*update", data)
    end

    def create_line_item_removed_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("line_items*destroy", removed_item_data)
    end

    def data
      {
        user_id: order.user_id,
        line_item_id: id
      }
    end

    def removed_item_data
      {
        user_id: order.user_id,
        name: name,
        order_number: order.number
      }
    end

    def quantity_updated_to_non_zero_quantity?
      saved_changes.include?(:quantity) && !saved_change_to_quantity.first.nil? && quantity != 0
    end

end
