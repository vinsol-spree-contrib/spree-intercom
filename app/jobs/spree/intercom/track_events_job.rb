class Spree::Intercom::TrackEventsJob < ApplicationJob

  def perform(name, options = {})
    resource, action = name.split('*')
    service_name = ::MAPPER[resource.classify.to_sym][action.to_sym]

    "Spree::Intercom::Events::#{resource.classify}::#{service_name}Service".constantize.new(options).register
  end
end
