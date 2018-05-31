Spree::UserSessionsController.class_eval do

  after_action :shutdown_intercom, only: :destroy

  private

    def shutdown_intercom
      begin
        cookies["intercom-session-#{Spree::Config.intercom_application_id}"] = { value: nil, expires: 1.day.ago, domain: :all }
      rescue
      end
    end

end
