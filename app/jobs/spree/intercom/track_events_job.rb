class Spree::Intercom::TrackEventsJob < ApplicationJob

  def perform(name, options = {})
    resource, action = name.split('_')
    service_name = INTERCOM_SERVICE_MAPPER[resource.underscore.to_sym][action.to_sym]

    service_name.new(options).register
  end
end
