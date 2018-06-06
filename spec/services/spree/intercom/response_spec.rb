require 'spec_helper'

RSpec.describe Spree::Intercom::Response, type: :service do

  Spree::Config.intercom_access_token = ''
  Spree::Config.intercom_application_id = ''

  let!(:data) { Intercom::User.new(email: "use30@mail.com", phone: "3212311234", name: "name", pseudonym: nil) }
  let!(:response) { Spree::Intercom::Response.new(data) }

  let!(:negative_data) { { response: {}, 'http_code' => 404, application_error_code: "not_found", field: nil, request_id: "b3ipdb2k8f6s", message: 'error' } }
  let!(:negative_response) { Spree::Intercom::Response.new(negative_data) }

  let!(:blank_response) { Spree::Intercom::Response.new({}) }

  describe '#initialize' do
    context 'when response is not blank' do
      it 'is expected to assign @response' do
        expect(response.instance_variable_get(:@response)).to eq(data.to_hash)
      end
    end

    context 'when response is blank' do
      it 'is expected to assign @response' do
        expect(blank_response.instance_variable_get(:@response)).to eq({})
      end
    end
  end

  describe '#success?' do
    context 'when failure? returns true' do
      before do
        allow(response).to receive(:failure?).and_return(true)
      end

      it 'is expected to return false' do
        expect(response.success?).to eq(false)
      end
    end

    context 'when failure? returns false' do
      before do
        allow(response).to receive(:failure?).and_return(false)
      end

      it 'is expected to return false' do
        expect(response.success?).to eq(true)
      end
    end
  end

  describe '#failure?' do
    context 'when response is nil' do
      it 'is expected to return false' do
        expect(blank_response.failure?).to eq(false)
      end
    end

    context 'when response is not nil' do
      context 'when response contains http_code' do
        context 'when http_code is between 400 and 504' do
          it 'is expected to return true' do
            expect(negative_response.failure?).to eq(true)
          end
        end

        context 'when response code is not between 400 and 504' do
          before do
            negative_response.response['http_code'] = 200
          end

          it 'is expected to return false' do
            expect(negative_response.failure?).to eq(false)
          end
        end
      end

      context 'when response does not contains http_code' do
        it 'is expected to return false' do
          expect(response.failure?).to eq(false)
        end
      end
    end
  end

  describe '#error_message' do
    context 'when response is success' do
      it 'is expect to return empty message' do
        expect(response.error_message).to eq(nil)
      end
    end

    context 'when response is failure' do
      it 'is expected to return error message' do
        expect(negative_response.error_message).to eq(negative_response.response[:message])
      end
    end
  end

  describe '#response' do
    it 'is expected to return intercom response' do
      expect(response.response).to eq(data.to_hash)
    end
  end

end
