require 'spec_helper'

RSpec.describe Spree::Intercom::BaseService, type: :service do

  Spree::Config.intercom_access_token = ''
  Spree::Config.intercom_application_id = ''

  let!(:base_service) { Spree::Intercom::BaseService.new }
  let!(:intercom) { Intercom::Client.new(token: Spree::Config.intercom_access_token) }

  describe 'attr_accessor :response' do
    it 'is expected to have a setter method' do
      expect(subject.respond_to?(:response=)).to eq(true)
    end

    it 'is expected to have a getter method' do
      expect(subject.respond_to?(:response)).to eq(true)
    end
  end

  describe '#initialize' do
    it 'is expected to set @intercom' do
      expect(base_service.instance_variable_get(:@intercom).class).to eq(intercom.class)
    end
  end

  describe '#create_response_object' do
    let!(:data) {
      { type: "location_data", city_name: "Delhi", continent_code: "AS", country_name: "India", latitude: 28.6667, longitude: 77.2167, postal_code: "110008", region_name: "Delhi" }
    }

    before do
      base_service.create_response_object(data)
    end

    it 'is expected to assign @response object of Spree::Intercom::Response' do
      expect(base_service.instance_variable_get(:@response).class).to eq(Spree::Intercom::Response)
    end
  end

  describe '#perform' do
    it do
      expect { base_service.perform }.to raise_error(Spree::Intercom::BaseService::NotImplementedError)
    end
  end

  describe '#send_request' do
    context 'when intercom processes request without exception' do
      let!(:intercom_data) {
        { type: "location_data", city_name: "Delhi", continent_code: "AS", country_name: "India", latitude: 28.6667, longitude: 77.2167, postal_code: "110008", region_name: "Delhi" }
      }

      before do
        allow(base_service).to receive(:perform).and_return(intercom_data)
        allow(base_service).to receive(:create_response_object).and_return(true)
      end

      it 'is expected to call create_response_object' do
        expect(base_service).to receive(:create_response_object)
        base_service.send_request
      end
    end

    context 'when intercom processes request with exception' do
      let!(:intercom_data) {
        { http_code: 404, application_error_code: "not_found", field: nil, request_id: "b3ipdb2k8f6shhfgdnng" }
      }

      before do
        allow(base_service).to receive(:perform).and_return(Intercom::ResourceNotFound)
        allow(base_service).to receive(:create_response_object).and_return(true)
      end

      it 'is expected to rescue error' do
        expect { base_service.send_request }.not_to raise_error
      end

      it 'is expected to call create_response_object' do
        expect(base_service).to receive(:create_response_object)
        base_service.send_request
      end

    end
  end

end
