require 'spec_helper'

RSpec.describe Spree::Intercom::Events::Customer::ReturnService, type: :service do

  Spree::Config.intercom_access_token = ''
  Spree::Config.intercom_application_id = ''

  let!(:customer_return) { create(:customer_return) }
  let!(:order) { customer_return.order }
  let!(:user) { order.user }

  let!(:options) {
    {
      customer_return_id: customer_return.id,
      order_id: order.id,
      user_id: user.id
    }
  }

  let!(:event_data) {
    {
      event_name: 'returned-order',
      created_at: customer_return.created_at,
      user_id: user.intercom_user_id,
      metadata: {
        order_number: order.number,
        return_number: customer_return.number
      }
    }
  }

  let!(:event_service) { Spree::Intercom::Events::Customer::ReturnService.new(options) }
  let!(:intercom) { Intercom::Client.new(token: Spree::Config.intercom_access_token) }

  it 'is expected to define EVENT_NAME' do
    expect(described_class::EVENT_NAME).to eq('returned-order')
  end

  describe '#initialize' do
    it 'is expected to set @user' do
      expect(event_service.instance_variable_get(:@user)).to eq(user)
    end

    it 'is expected to set @intercom' do
      expect(event_service.instance_variable_get(:@order)).to eq(order)
    end

    it 'is expected to set @return' do
      expect(event_service.instance_variable_get(:@return)).to eq(customer_return)
    end
  end

  describe '#perform' do
    before do
      allow_any_instance_of(Intercom::Client).to receive_message_chain(:events, :create).with(event_data) { 'response' }
    end

    it 'is expected to create event on Interom' do
      expect(intercom.events.create(event_data)).to eq('response')
    end

    after do
      event_service.perform
    end
  end

  describe '#register' do
    before do
      allow(event_service).to receive(:send_request).and_return(true)
    end

    it 'is expected to call send_request' do
      expect(event_service).to receive(:send_request).and_return(true)
    end

    after { event_service.register }
  end

  describe '#event_data' do
    it 'is expected to return hash' do
      expect(event_service.event_data).to eq(event_data)
    end
  end

end
