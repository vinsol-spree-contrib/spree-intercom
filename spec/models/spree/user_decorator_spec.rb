require 'spec_helper'

RSpec.describe Spree::User, type: :model do

  let!(:user) { create(:user) }
  let!(:user1) { create(:user) }

  describe '.has_secure_token' do
    before { user.regenerate_intercom_user_id }

    it 'is expected not to create same token for two users' do
      expect(user.intercom_user_id).not_to eq(user1.intercom_user_id)
    end
  end

  describe 'Callbacks' do
    it { is_expected.to callback(:create_user_on_intercom).after(:commit) }
    it { is_expected.to callback(:update_user_on_intercom).after(:commit).if(:user_intercom_attributes_changed?) }
  end

  describe 'Validations' do
    it { is_expected.to validate_uniqueness_of(:intercom_user_id).case_insensitive }
  end

  describe '#create_user_on_intercom' do
    before { ActiveJob::Base.queue_adapter = :test }

    it 'is expected to enqueue CreateUserJob' do
      expect {
        user.send :create_user_on_intercom
      }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
    end
  end

  describe '#update_user_on_intercom' do
    before { ActiveJob::Base.queue_adapter = :test }

    it 'is expected to enqueue UpdateUserJob' do
      expect {
        user.send :update_user_on_intercom
      }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
    end
  end

  describe '#user_intercom_attributes_changed?' do
    context 'when email is changed' do
      before do
        user.email = 'new_email@mail.com'
        user.save!
      end

      it 'is expected to return true' do
        expect(user.send :user_intercom_attributes_changed?).to eq(true)
      end
    end

    context 'when last_sign_in_ip is changed' do
      before do
        user.last_sign_in_ip = '192.122.12.3'
        user.save!
      end

      it 'is expected to return true' do
        expect(user.send :user_intercom_attributes_changed?).to eq(true)
      end
    end

    context 'when other attributes are changed' do
      before do
        user.persistence_token = 'new_token'
        user.save!
      end

      it 'is expected to return false' do
        expect(user.send :user_intercom_attributes_changed?).to eq(false)
      end
    end
  end

end
