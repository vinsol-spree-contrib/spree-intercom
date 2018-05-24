class Spree::Intercom::UserUpdationJob < ApplicationJob

  def perform(id)
    Spree::Intercom::UpdateUserService.new(id).update
  end

end
