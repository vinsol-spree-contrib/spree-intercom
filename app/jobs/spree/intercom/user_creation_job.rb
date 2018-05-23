class Spree::Intercom::UserCreationJob < ApplicationJob

  queue_as :default

  def perform(id)
    Spree::Intercom::UserCreationService.new(id).call
  end
end