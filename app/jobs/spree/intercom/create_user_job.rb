class Spree::Intercom::CreateUserJob < ApplicationJob

  def perform(id)
    if Spree::Config.enable_intercom
      Spree::Intercom::CreateUserService.new(id).create
    end
  end

end
