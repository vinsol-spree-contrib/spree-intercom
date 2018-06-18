class Spree::Intercom::CreateUserJob < ApplicationJob

  def perform(id)
    Spree::Intercom::CreateUserService.new(id).create
  end

end
