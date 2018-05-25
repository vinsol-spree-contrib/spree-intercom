class Spree::Intercom::Events::CreateUserJob < ApplicationJob

  def perform(id)
    Spree::Intercom::Events::CreateUserService.new(id).register
  end

end
