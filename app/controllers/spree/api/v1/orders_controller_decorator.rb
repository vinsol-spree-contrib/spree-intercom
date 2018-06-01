Spree::Api::V1::OrdersController.class_eval do

  def apply_coupon_code
    find_order
    authorize! :update, @order, order_token
    @order.coupon_code = params[:coupon_code]
    @handler = Spree::PromotionHandler::Coupon.new(@order).apply
    status = @handler.successful? ? 200 : 422

    if status == 200
      Spree::Intercom::TrackEventsJob.perform_later("OrderPromotion_create", create_data)
    end

    render 'spree/api/v1/promotions/handler', status: status
  end

  private

    def create_data
      {
        code: params[:coupon_code],
        order_id: @order.id,
        time: Time.current.to_i,
        user_id: @order.user_id
      }
    end
end
