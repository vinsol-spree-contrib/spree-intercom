require 'spec_helper'

RSpec.describe Spree::OrderPromotion, type: :model do

  let!(:order) { create(:order) }
  let!(:order_without_user) { create(:order, user_id: nil) }
  let!(:promotion) { Spree::OrderPromotion.new(order_id: order.id) }
  let!(:promotion_without_user) { Spree::OrderPromotion.new(order_id: order_without_user.id) }
  let!(:destroy_data) {
    {
      order_id: order.id,
      promotion_id: promotion.id,
      time: Time.current.to_i,
      user_id: order.user_id
    }
  }

  it 'is expected to include Spree::EventTracker' do
    expect(described_class.ancestors.include?(Spree::EventTracker)).to eq(true)
  end

  describe 'Spree::EventTracker' do
    before do
      allow_any_instance_of(described_class).to receive(:action_name).and_return(:destroy)
      allow_any_instance_of(described_class).to receive(:destroy_data).and_return(destroy_data)
    end

    it_behaves_like 'event_tracker'
  end

  describe 'Callbacks' do
    it { is_expected.to callback(:create_event_on_intercom).after(:commit).if(:user_present?) }
  end

  describe '#user_present?' do
    context 'when user is present' do
      it 'is expected to return true' do
        expect(promotion.send :user_present?).to eq(true)
      end
    end

    context 'when user is not present' do
      it 'is expected to return false' do
        expect(promotion_without_user.send :user_present?).to eq(false)
      end
    end
  end

  describe '#destroy_data' do
    it 'is expected to return hash' do
      expect(promotion.send :destroy_data).to eq(destroy_data)
    end
  end

end
