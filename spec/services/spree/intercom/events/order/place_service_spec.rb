require 'spec_helper'

RSpec.describe Spree::Intercom::Events::Order::PlaceService, type: :service do

  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }

  let!(:options) {
    {
      order_id: order.id,
      user_id: user.id
    }
  }

  let!(:event_data) {
    {
      event_name: 'placed-order',
      created_at: order.updated_at,
      user_id: user.intercom_user_id,
      metadata: {
        order_number: {
          url: "http://localhost:3000/orders/#{order.number}",
          value: order.number
        },
        price: {
          amount: order.amount,
          currency: order.currency
        }
      }
    }
  }

  let!(:event_service) { Spree::Intercom::Events::Order::PlaceService.new(options) }
  let!(:intercom) { Intercom::Client.new(token: Spree::Config.intercom_access_token) }

  it 'is expected to define EVENT_NAME' do
    expect(described_class::EVENT_NAME).to eq('placed-order')
  end

  describe '#initialize' do
    it 'is expected to set @user' do
      expect(event_service.instance_variable_get(:@user)).to eq(user)
    end

    it 'is expected to set @order' do
      expect(event_service.instance_variable_get(:@order)).to eq(order)
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

  describe '#order_url' do
    context 'when host is specified' do
      before { Rails.application.routes.default_url_options[:host] = "test.com" }

      context 'when protocol is specified' do
        before { Rails.application.routes.default_url_options[:protocol] = "https" }

        it 'is expected to return order url' do
          expect(event_service.send :order_url).to eq("https://test.com/orders/#{order.number}")
        end

        after { Rails.application.routes.default_url_options[:protocol] = "http" }
      end

      context 'when protocol is not specified' do
        it 'is expected to return order url' do
          expect(event_service.send :order_url).to eq("http://test.com/orders/#{order.number}")
        end
      end

      after { Rails.application.routes.default_url_options[:host] = "localhost:3000" }
    end

    context 'when host is not specified' do
      context 'when protocol is specified' do
        before { Rails.application.routes.default_url_options[:protocol] = "https" }

        it 'is expected to return order url' do
          expect(event_service.send :order_url).to eq("https://localhost:3000/orders/#{order.number}")
        end

        after { Rails.application.routes.default_url_options[:protocol] = "http" }
      end

      context 'when protocol is not specified' do
        it 'is expected to return order url' do
          expect(event_service.send :order_url).to eq("http://localhost:3000/orders/#{order.number}")
        end
      end
    end
  end

  describe '#host_name' do
    context 'when host is not specified' do
      it 'is expected to return localhost' do
        expect(event_service.send :host_name).to eq('localhost:3000')
      end
    end

    context 'when host is specified' do
      before { Rails.application.routes.default_url_options[:host] = "test.com" }

      it 'is expected to return the specified host' do
        expect(event_service.send :host_name).to eq('test.com')
      end

      after { Rails.application.routes.default_url_options[:host] = "localhost:3000" }
    end
  end

  describe '#protocol_name' do
    context 'when protocol is not specified' do
      it 'is expected to return http' do
        expect(event_service.send :protocol_name).to eq('http')
      end
    end

    context 'when protocol is specified' do
      before { Rails.application.routes.default_url_options[:protocol] = "https" }

      it 'is expected to return the specified protocol' do
        expect(event_service.send :protocol_name).to eq('https')
      end

      after { Rails.application.routes.default_url_options[:protocol] = "http" }
    end
  end

end
