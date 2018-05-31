require 'spec_helper'

RSpec.describe Spree::Intercom::UpdateUserService, type: :service do

  Spree::Config.intercom_access_token = ''
  Spree::Config.intercom_application_id = ''

  let!(:user) { create(:user) }
  let!(:user_service) { Spree::Intercom::UpdateUserService.new(user.id) }
  let!(:intercom) { Intercom::Client.new(token: Spree::Config.intercom_access_token) }
  let!(:user_data) { Spree::Intercom::UserSerializer.new(user).serializable_hash }

  describe '#initialize' do
    it 'is expected to set @user' do
      expect(user_service.instance_variable_get(:@user)).to eq(user)
    end

    it 'is expected to set @intercom' do
      expect(user_service.instance_variable_get(:@intercom).class).to eq(intercom.class)
    end
  end

  describe '#perform' do
    before do
      allow_any_instance_of(Intercom::Client).to receive_message_chain(:users, :find).with(user_id: user.intercom_user_id) { user }
      allow(user).to receive(:name=).and_return(user)
      allow(user).to receive(:phone=).and_return(user)
      allow(user).to receive(:last_seen_ip=).and_return(user)
      allow(user).to receive(:signed_up_at=).and_return(user)
      allow(user).to receive(:user_id=).and_return(user)
      allow_any_instance_of(Intercom::Client).to receive_message_chain(:users, :save).with(user) { 'response' }
    end

    it 'is expected to update user' do
      expect(intercom.users.save(user)).to eq('response')
    end

    after do
      user_service.perform
    end
  end

  describe '#update' do
    before do
      allow(user_service).to receive(:send_request).and_return(true)
    end

    it 'is expected to call update' do
      expect(user_service).to receive(:send_request).and_return(true)
    end

    after { user_service.update }
  end

end
