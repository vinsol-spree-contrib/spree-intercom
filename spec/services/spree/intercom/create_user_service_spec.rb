require 'spec_helper'

RSpec.describe Spree::Intercom::CreateUserService, type: :service do

  Spree::Config.intercom_access_token = ''
  Spree::Config.intercom_application_id = ''

  let!(:user) { create(:user) }
  let!(:user_service) { Spree::Intercom::CreateUserService.new(user.id) }
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
      allow_any_instance_of(Intercom::Client).to receive_message_chain(:users, :create).with(user_data) { 'response' }
    end

    it 'is expected to create user' do
      expect(intercom.users.create(user_data)).to eq('response')
    end

    after do
      user_service.perform
    end
  end

  describe '#user_data' do
    it 'is expected to return serialized user data' do
      expect(user_service.user_data).to eq(user_data)
    end
  end

  describe '#create' do
    before do
      allow(user_service).to receive(:send_request).and_return(true)
    end

    it 'is expected to call create' do
      expect(user_service).to receive(:send_request).and_return(true)
    end

    after { user_service.create }
  end

end
