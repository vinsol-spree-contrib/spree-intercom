class Spree::Intercom::TrackEventsJob < ApplicationJob

  def perform(name, options = {})
    resource, action = name.split('_')
    service_name = SERVICE_MAPPER[resource.to_sym][action.to_sym]

    service_name.constantize.new(options).register
  end
end
