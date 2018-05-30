module Spree
  module ControllerEventTracker
    extend ActiveSupport::Concern

    private

      def create_event_on_intercom
        return unless user_present?
        return unless product_index_not_search?
        Spree::Intercom::TrackEventsJob.perform_later("#{controller_name.classify}_#{action_name}", send("#{action_name}_data"))
      end

      def user_present?
        spree_current_user.present? || (controller_name == 'user_sessions' && action_name == 'destroy')
      end

      def product_index_not_search?
        return true unless (controller_name == 'products' && action_name == 'index')
        searched?
      end

  end
end
