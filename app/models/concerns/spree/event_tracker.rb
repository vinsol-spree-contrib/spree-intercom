module Spree
  module EventTracker
    extend ActiveSupport::Concern

    private

      def create_event_on_intercom
        Spree::Intercom::TrackEventsJob.perform_later("#{self.class.name.demodulize}_#{action_name}", send("#{action_name}_data"))
      end

      def action_name
        if is_a?(Order)
          complete? ? :placed : :update
        else
          return :create if resource_created?
          return :update if resource_updated?
          return :destroy if resource_destroyed?
        end
      end

      def resource_created?
        persisted? && transaction_include_any_action?([:create])
      end

      def resource_updated?
        persisted? && transaction_include_any_action?([:update])
      end

      def resource_destroyed?
        !persisted?
      end

  end
end
