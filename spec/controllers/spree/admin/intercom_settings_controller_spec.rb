require 'spec_helper'

describe Spree::Admin::IntercomSettingsController, type: :controller do

  describe 'GET #edit' do
    stub_authorization!
    before { get :edit }
    it { is_expected.to render_template :edit }
  end

  describe 'PATCH #update' do
    stub_authorization!
    before do
      patch :update, params: { intercom_application_id: 'id123', intercom_access_token: 'tok123' }
    end

    it 'is expected to save the updated value of application_id' do
      expect(Spree::Config.intercom_application_id).to eq('id123')
    end

    it 'is expected to save the updated value of access_token' do
      expect(Spree::Config.intercom_access_token).to eq('tok123')
    end

    it { is_expected.to set_flash[:success].to(Spree.t(:successfully_updated, resource: Spree.t(:intercom_settings))) }

    it { is_expected.to redirect_to(edit_admin_intercom_setting_path) }

  end

end