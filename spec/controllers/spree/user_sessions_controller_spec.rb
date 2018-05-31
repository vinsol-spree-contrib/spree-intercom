require 'spec_helper'

describe Spree::UserSessionsController, type: :controller do

  before do
    allow(controller).to receive(:spree_current_user).and_return(user)
  end

  let!(:user) { create(:user) }

  let!(:data) {
    {
      time: Time.current.to_i,
      user_id: user.id
    }
  }

  it { is_expected.to use_before_action(:destroy_data) }
  it { is_expected.to use_after_action(:shutdown_intercom) }
  it { is_expected.to use_after_action(:create_event_on_intercom) }

  describe '#shutdown_intercom' do
    before do
      subject.send :shutdown_intercom
    end

    it 'is expected to expire intercom cookies' do
      expect(cookies["intercom-session-#{Spree::Config.intercom_application_id}"]).to eq(nil)
    end
  end

  describe '#create_data' do

    it 'is expected to return hash of show data' do
      expect(controller.send :create_data).to eq(data)
    end
  end

  describe '#destroy_data' do
    it 'is expected to assign @data' do
      controller.send :destroy_data
      expect(assigns(:data)).to eq(data)
    end

    it 'is expected to call create_data' do
      expect(controller).to receive(:create_data)
      controller.send :destroy_data
    end
  end

end
