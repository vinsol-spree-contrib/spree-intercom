require 'spec_helper'

RSpec.describe Spree::Intercom::Events::LineItem::DeleteService, type: :service do

  let!(:line_item) { create(:line_item) }
  let!(:order) { line_item.order }
  let!(:user) { line_item.order.user }
  let!(:variant) { line_item.variant }
  let!(:order_url) { Spree::Core::Engine.routes.url_helpers.order_url(order, host: 'localhost:3000', protocol: 'http') }

  let!(:options) {
    {
      name: line_item.name,
      order_number: order.number,
      sku: variant.sku,
      time: Time.current.to_i,
      user_id: user.id
    }
  }

  let!(:event_data) {
    {
      event_name: 'removed-product',
      created_at: options[:time],
      user_id: user.intercom_user_id,
      metadata: {
        order_number: {
          url: order_url,
          value: order.number
        },
        product: options[:name],
        sku: options[:sku]
      }
    }
  }

  let!(:event_service) { Spree::Intercom::Events::LineItem::DeleteService.new(options) }
  let!(:intercom) { Intercom::Client.new(token: Spree::Config.intercom_access_token) }

  it 'is expected to define EVENT_NAME' do
    expect(described_class::EVENT_NAME).to eq('removed-product')
  end

  describe '#initialize' do
    it 'is expected to set @user' do
      expect(event_service.instance_variable_get(:@user)).to eq(user)
    end

    it 'is expected to set @time' do
      expect(event_service.instance_variable_get(:@time)).to eq(options[:time])
    end

    it 'is expected to set @order' do
      expect(event_service.instance_variable_get(:@order)).to eq(order)
    end

    it 'is expected to set @sku' do
      expect(event_service.instance_variable_get(:@sku)).to eq(options[:sku])
    end

    it 'is expected to set @name' do
      expect(event_service.instance_variable_get(:@name)).to eq(options[:name])
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

  it_behaves_like 'order_url'
end
