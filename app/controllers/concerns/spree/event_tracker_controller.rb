module Spree
  module EventTrackerController
    extend ActiveSupport::Concern

    private

      def create_event_on_intercom
        if conditions_satisfied?
          Spree::Intercom::TrackEventsJob.perform_later("#{controller_name.classify}_#{action_name}", send("#{action_name}_data"))
        end
      end

      def conditions_satisfied?
        user_present? && product_search_conditions_satisfied?
      end

      def user_present?
        spree_current_user.present? || (controller_name == 'user_sessions' && action_name == 'destroy')
      end

      def product_search_conditions_satisfied?
        return true unless (controller_name == 'products' && action_name == 'index')
        product_searched_by_user?
      end

  end
end
