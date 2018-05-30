module Spree
  module ModelEventTracker
    extend ActiveSupport::Concern

    private

      def create_event_on_intercom
        if conditions_satisfied?
          Spree::Intercom::TrackEventsJob.perform_later("#{self.class.name.demodulize}_#{action_name}", send("#{action_name}_data"))
        end
      end

      def conditions_satisfied?
        line_item_conditions_satisfied?
      end

      def line_item_conditions_satisfied?
        return true unless is_a?(LineItem)

        if resource_updated?
          quantity_updated_to_non_zero_value?
        else
          true
        end
      end

      def action_name
        return :create if resource_created?
        return :update if resource_updated?
        return :destroy if resource_destroyed?
      end

      # used try becuase OrderPromotion does not have timestamps

      # when resource is created, id is changed from nil to a value
      def resource_created?
        persisted? && try(:created_at).to_i == try(:updated_at).to_i
      end

      def resource_updated?
        persisted? && try(:created_at).to_i != try(:updated_at).to_i
      end

      def resource_destroyed?
        !persisted?
      end

  end
end
