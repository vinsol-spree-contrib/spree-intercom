class Spree::Intercom::UpdateUserJob < ApplicationJob

  def perform(id)
    Spree::Intercom::UpdateUserService.new(id).update
  end

end
