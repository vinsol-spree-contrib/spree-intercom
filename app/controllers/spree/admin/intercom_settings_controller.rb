class Spree::Admin::IntercomSettingsController < Spree::Admin::BaseController

  def update
    params.each do |name, value|
      next unless Spree::Config.has_preference? name
      Spree::Config[name] = value
    end

    flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:intercom_settings))
    redirect_to edit_admin_intercom_setting_path
  end
end