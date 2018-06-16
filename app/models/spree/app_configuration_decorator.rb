Spree::AppConfiguration.class_eval do
  preference :intercom_application_id, :string
  preference :intercom_access_token, :string
  preference :enable_intercom, :boolean, default: true
end
