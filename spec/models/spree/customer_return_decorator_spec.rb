require 'spec_helper'

RSpec.describe Spree::CustomerReturn, type: :model do

  let!(:customer_return) { create(:customer_return) }
  let!(:create_data) {
    {
      customer_return_id: customer_return.id,
      order_id: customer_return.order.id,
      user_id: customer_return.order.user_id
    }
  }

  it 'is expected to include Spree::EventTracker' do
    expect(described_class.ancestors.include?(Spree::EventTracker)).to eq(true)
  end

  describe 'Spree::EventTracker' do
    before do
      allow_any_instance_of(described_class).to receive(:action_name).and_return(:create)
      allow_any_instance_of(described_class).to receive(:create_data).and_return(create_data)
    end

    it_behaves_like 'event_tracker'
  end

  describe 'Callbacks' do
    it { is_expected.to callback(:create_event_on_intercom).after(:commit).if(:user_present?) }
  end

  describe '#user_present?' do
    context 'when user is present' do
      it 'is expected to return true' do
        expect(customer_return.send :user_present?).to eq(true)
      end
    end

    context 'when user is not present' do
      before {
         order = customer_return.order
         order.update_column(:user_id, nil)
      }

      it 'is expected to return false' do
        expect(customer_return.send :user_present?).to eq(false)
      end
    end
  end

  describe '#create_data' do
    it 'is expected to return hash' do
      expect(customer_return.send :create_data).to eq(create_data)
    end
  end

end
