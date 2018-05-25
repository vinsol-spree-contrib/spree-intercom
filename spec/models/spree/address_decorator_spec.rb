require 'spec_helper'

RSpec.describe Spree::Address, type: :model do

  let!(:address) { create(:address) }
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id, bill_address_id: address.id) }

  describe 'Callbacks' do
    it { is_expected.to callback(:update_user_on_intercom).after(:commit).if(:user_intercom_attributes_changed?) }
  end

  describe '#update_user_on_intercom' do
    context 'when user is present' do
      before { ActiveJob::Base.queue_adapter = :test }

      it 'is expected to enqueue UpdateUserJob' do
        expect {
          address.send :update_user_on_intercom
        }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
      end

      context 'when bill_address is present' do
        let!(:user) { create(:user, bill_address_id: address.id) }
        before { address.send :update_user_on_intercom }

        it 'is expected not to call persist_order_address' do
          expect(user).not_to receive(:persist_order_address)
        end

        after { address.send :update_user_on_intercom }
      end

      context 'when bill_address is not present' do
        let!(:user) { create(:user, bill_address_id: address.id) }

        it 'is expected not to call persist_order_address' do
          expect(user).not_to receive(:persist_order_address)
        end

        after { address.send :update_user_on_intercom }
      end

    end

    context 'when order is not present' do
      let(:order) { nil }
      before { ActiveJob::Base.queue_adapter = :test }

      it 'is not expected to enqueue UpdateUserJob' do
        expect {
          address.send :update_user_on_intercom
        }.not_to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }
      end
    end

  end

  describe '#user_intercom_attributes_changed?' do
    context 'when phone is changed' do
      before do
        address.phone = '123'
        address.save!
      end

      it 'is expected to return true' do
        expect(address.send :user_intercom_attributes_changed?).to eq(true)
      end
    end

    context 'when firstname is changed' do
      before do
        address.firstname = 'new'
        address.save!
      end

      it 'is expected to return true' do
        expect(address.send :user_intercom_attributes_changed?).to eq(true)
      end
    end

    context 'when lastname is changed' do
      before do
        address.lastname = 'new'
        address.save!
      end

      it 'is expected to return true' do
        expect(address.send :user_intercom_attributes_changed?).to eq(true)
      end
    end

    context 'when other attributes are changed' do
      before do
        address.city = 'new city'
        address.save!
      end

      it 'is expected to return false' do
        expect(address.send :user_intercom_attributes_changed?).to eq(false)
      end
    end
  end

end
