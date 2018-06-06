Spree::PromotionHandler::Coupon.class_eval do

  def set_success_code(code)
    @status_code = code
    @success = Spree.t(code)

    Spree::Intercom::TrackEventsJob.perform_later("#{self.class.name.demodulize}_create", create_data)
  end

  private

    def create_data
      {
        code: @order.coupon_code,
        order_id: @order.id,
        time: Time.current.to_i,
        user_id: @order.user_id
      }
    end

end
