require 'spec_helper'

RSpec.shared_examples 'order_url' do

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
