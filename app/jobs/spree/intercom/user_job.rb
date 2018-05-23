class Spree::Intercom::UserJob < ApplicationJob

  queue_as :default

  def perform(id)
    Spree::Intercom::UserService.new(id).create
  end
end