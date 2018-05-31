module Spree
  module EventTrackerController
    extend ActiveSupport::Concern

    private

      def create_event_on_intercom
        if user_present?
          Spree::Intercom::TrackEventsJob.perform_later("#{controller_name.classify}_#{action_name}", send("#{action_name}_data"))
        end
      end

      def user_present?
        spree_current_user.present? || user_logged_out?
      end

      def user_logged_out?
        controller_name == 'user_sessions' && action_name == 'destroy'
      end

  end
end
