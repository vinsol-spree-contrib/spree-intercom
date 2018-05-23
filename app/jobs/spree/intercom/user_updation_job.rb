class Spree::Intercom::UserUpdationJob < ApplicationJob

  queue_as :default

  def perform(id)
    Spree::Intercom::UserUpdationService.new(id).call
  end
end