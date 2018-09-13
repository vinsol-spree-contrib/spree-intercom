require 'spec_helper'

RSpec.describe Spree::Intercom::Events::Product::ViewService, type: :service do

  let!(:user) { create(:user) }
  let!(:product) { create(:product) }

  let!(:options) {
    {
      product_id: product.id,
      time: Time.current.to_i,
      user_id: user.id
    }
  }

  let!(:event_data) {
    {
      event_name: 'viewed-product',
      created_at: options[:time],
      user_id: user.intercom_user_id,
      metadata: {
        product: product.name
      }
    }
  }

  let!(:event_service) { Spree::Intercom::Events::Product::ViewService.new(options) }
  let!(:intercom) { Intercom::Client.new(token: Spree::Config.intercom_access_token) }

  it 'is expected to define EVENT_NAME' do
    expect(described_class::EVENT_NAME).to eq('viewed-product')
  end

  describe '#initialize' do
    it 'is expected to set @product' do
      expect(event_service.instance_variable_get(:@product)).to eq(product)
    end

    it 'is expected to set @user' do
      expect(event_service.instance_variable_get(:@user)).to eq(user)
    end

    it 'is expected to set @time' do
      expect(event_service.instance_variable_get(:@time)).to eq(options[:time])
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
