require 'spec_helper'

RSpec.describe Spree::Shipment, type: :model do

  let!(:order) { create(:order) }
  let!(:order_without_user) { create(:order, user_id: nil) }
  let!(:shipment) { create(:shipment, state: 'ready', order: order) }
  let!(:shipment_without_user) { create(:shipment, state: 'ready', order: order_without_user) }
  let!(:update_data) {
    {
      order_id: order.id,
      shipment_id: shipment.id,
      user_id: order.user_id
    }
  }

  it 'is expected to include Spree::EventTracker' do
    expect(described_class.ancestors.include?(Spree::EventTracker)).to eq(true)
  end

  describe 'Spree::EventTracker' do
    before do
      allow_any_instance_of(described_class).to receive(:action_name).and_return(:update)
      allow_any_instance_of(described_class).to receive(:update_data).and_return(update_data)
    end

    it_behaves_like 'event_tracker'
  end

  describe '#after_transition' do
    context 'when user is present' do
      context 'when state is changed to shipped' do
        it 'is expected to run create_event_on_intercom' do
          expect(shipment).to receive(:create_event_on_intercom)
          shipment.ship!
        end
      end
    end

    context 'when user is not present' do
      it 'is not expected to run create_event_on_intercom' do
        expect(shipment_without_user).not_to receive(:create_event_on_intercom)
        shipment_without_user.ship!
      end
    end
  end

  describe '#user_present?' do
    context 'when user is present' do
      it 'is expected to return true' do
        expect(shipment.send :user_present?).to eq(true)
      end
    end

    context 'when user is not present' do
      it 'is expected to return false' do
        expect(shipment_without_user.send :user_present?).to eq(false)
      end
    end
  end

  describe '#update_data' do
    it 'is expected to return hash' do
      expect(shipment.send :update_data).to eq(update_data)
    end
  end

end
