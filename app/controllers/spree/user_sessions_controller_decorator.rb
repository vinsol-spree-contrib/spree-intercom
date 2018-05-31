Spree::UserSessionsController.class_eval do

  include Spree::EventTrackerController

  before_action :destroy_data, only: :destroy  # done because spree_current_user wont be available after log out
  after_action :shutdown_intercom, only: :destroy
  after_action :create_event_on_intercom, only: [:create, :destroy]

  private

    def shutdown_intercom
      begin
        cookies["intercom-session-#{Spree::Config.intercom_application_id}"] = { value: nil, expires: 1.day.ago, domain: :all }
      rescue
      end
    end

    def create_data
      {
        time: Time.current.to_i,
        user_id: spree_current_user.id
      }
    end

    def destroy_data
      @data ||= create_data
    end

end
