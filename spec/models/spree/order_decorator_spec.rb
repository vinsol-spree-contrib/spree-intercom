require 'spec_helper'

RSpec.describe Spree::Order, type: :model do

  let!(:order) { create(:order, state: 'cart') }
  let!(:order_without_user) { create(:order, user_id: nil) }
  let!(:line_item) { create(:line_item) }
  let!(:set_data) {
    {
      order_id: order.id,
      user_id: order.user_id
    }
  }

  it 'is expected to include Spree::EventTracker' do
    expect(described_class.ancestors.include?(Spree::EventTracker)).to eq(true)
  end

  describe 'Spree::EventTracker' do
    context 'when action is placed' do
      before do
        allow_any_instance_of(described_class).to receive(:action_name).and_return(:placed)
        allow_any_instance_of(described_class).to receive(:placed_data).and_return(set_data)
      end

      it_behaves_like 'event_tracker'
    end

    context 'when action is update' do
      before do
        allow_any_instance_of(described_class).to receive(:action_name).and_return(:update)
        allow_any_instance_of(described_class).to receive(:update_data).and_return(set_data)
      end

      it_behaves_like 'event_tracker'
    end
  end

  it 'is expected to define INTERCOM_ORDER_STATES' do
    expect(INTERCOM_ORDER_STATES).to eq([:cart, :address, :delivery, :payment, :confirm, :complete])
  end

  describe '#after_transition' do
    context 'when user is present' do
      context 'when state is changed to address' do
        it 'is expected to run create_event_on_intercom' do
          expect(order).to receive(:create_event_on_intercom)
          order.line_items << line_item
          order.next
        end
      end
    end

    context 'when user is not present' do
      it 'is not expected to run create_event_on_intercom' do
        expect(order_without_user).not_to receive(:create_event_on_intercom)
        order_without_user.line_items << line_item
        order_without_user.next
      end
    end
  end

  describe '#set_data' do
    it 'is expected to return hash' do
      expect(order.send :set_data).to eq(set_data)
    end
  end

  describe '#update_data' do
    it 'is expected to call set_data' do
      expect(order).to receive(:set_data)
      order.send :update_data
    end
  end

  describe '#placed_data' do
    it 'is expected to call set_data' do
      expect(order).to receive(:set_data)
      order.send :placed_data
    end
  end

  describe '#user_present?' do
    context 'when user is present' do
      it 'is expected to return true' do
        expect(order.send :user_present?).to eq(true)
      end
    end

    context 'when user is not present' do
      it 'is expected to return false' do
        expect(order_without_user.send :user_present?).to eq(false)
      end
    end
  end

end
