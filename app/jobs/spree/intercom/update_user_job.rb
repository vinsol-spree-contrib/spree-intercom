class Spree::Intercom::UpdateUserJob < ApplicationJob

  def perform(id)
    if Spree::Config.enable_intercom
      Spree::Intercom::UpdateUserService.new(id).update
    end
  end

end
