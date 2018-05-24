class Spree::Intercom::UserCreationJob < ApplicationJob

  def perform(id)
    Spree::Intercom::CreateUserService.new(id).create
  end

end
