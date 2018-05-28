class Spree::Intercom::Events::ProductViewJob < ApplicationJob

  def perform(id, product_id)
    Spree::Intercom::Events::ProductViewService.new(id, product_id).register
  end

end
