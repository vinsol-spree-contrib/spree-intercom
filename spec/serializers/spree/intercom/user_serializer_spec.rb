require 'spec_helper'

RSpec.describe Spree::Intercom::UserSerializer, type: :serializer do

  let!(:address) { create(:address) }
  let!(:user) { create(:user, bill_address_id: address.id) }
  let!(:user_without_address) { create(:user) }

  let!(:serialized_data_user) { Spree::Intercom::UserSerializer.new(user).serializable_hash }
  let!(:serialized_data_user_without_address) { Spree::Intercom::UserSerializer.new(user_without_address).serializable_hash }

  describe 'email' do
    it 'is expected to have a email' do
      expect(serialized_data_user[:email]).to eq(user.email)
    end
  end

  describe 'name' do
    context 'when address is present' do
      it 'is expected to have a name' do
        expect(serialized_data_user[:name]).to eq("#{user.bill_address.first_name} #{user.bill_address.last_name}")
      end
    end

    context 'when address is not present' do
      it 'is expected not to have a name' do
        expect(serialized_data_user_without_address[:name]).to eq(nil)
      end
    end
  end

  describe 'phone' do
    context 'when address is present' do
      it 'is expected to have a phone' do
        expect(serialized_data_user[:phone]).to eq(user.bill_address.phone)
      end
    end

    context 'when address is not present' do
      it 'is expected not to have a phone' do
        expect(serialized_data_user_without_address[:phone]).to eq(nil)
      end
    end
  end

  describe 'last_seen_ip' do
    it 'is expected to have a last_seen_ip' do
      expect(serialized_data_user[:last_seen_ip]).to eq(user.last_sign_in_ip)
    end
  end

  describe 'signed_up_at' do
    it 'is expected to have a signed_up_at' do
      expect(serialized_data_user[:signed_up_at]).to eq(user.created_at)
    end
  end

  describe 'user_id' do
    it 'is expected to have a user_id' do
      expect(serialized_data_user[:user_id]).to eq(user.intercom_user_id)
    end
  end

  describe '#address_present?' do
    context 'when address is present' do
      let!(:serializer) { Spree::Intercom::UserSerializer.new(user) }

      it 'is expected to return true' do
        expect(serializer.address_present?).to eq(true)
      end
    end

    context 'when address is not present' do
      let!(:serializer) { Spree::Intercom::UserSerializer.new(user_without_address) }

      it 'is expected to return true' do
        expect(serializer.address_present?).to eq(false)
      end
    end
  end

  describe 'number_of_orders' do
    it 'is expected to have a number_of_orders' do
      expect(serialized_data_user[:number_of_orders]).to eq(user.completed_orders_count)
    end
  end
end
