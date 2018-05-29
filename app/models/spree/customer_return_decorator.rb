Spree::CustomerReturn.class_eval do

  after_commit :create_order_return_event_on_intercom, on: :create, if: :order_returned_by_user?

  private

    def create_order_return_event_on_intercom
      Spree::Intercom::TrackEventsJob.perform_later("customer_return*create", data)
    end

    def order_returned_by_user?
      order.user_id.present?
    end

    def data
      {
        customer_return_id: id,
        order_id: order_id,
        user_id: order.user_id
      }
    end

end
