require 'spec_helper'

RSpec.describe Spree::Intercom::Events::Shipment::ShipService, type: :service do

  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }
  let!(:shipment) { create(:shipment, state: 'ready', order: order) }

  let!(:options) {
    {
      order_id: order.id,
      shipment_id: shipment.id,
      user_id: user.id
    }
  }

  let!(:event_data) {
    {
      event_name: 'shipped-order',
      created_at: shipment.updated_at,
      user_id: user.intercom_user_id,
      metadata: {
        order_number: order.number,
        shipment_number: shipment.number
      }
    }
  }

  let!(:event_service) { Spree::Intercom::Events::Shipment::ShipService.new(options) }
  let!(:intercom) { Intercom::Client.new(token: Spree::Config.intercom_access_token) }

  it 'is expected to define EVENT_NAME' do
    expect(described_class::EVENT_NAME).to eq('shipped-order')
  end

  describe '#initialize' do
    it 'is expected to set @order' do
      expect(event_service.instance_variable_get(:@order)).to eq(order)
    end

    it 'is expected to set @user' do
      expect(event_service.instance_variable_get(:@user)).to eq(user)
    end

    it 'is expected to set @shipment' do
      expect(event_service.instance_variable_get(:@shipment)).to eq(shipment)
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
