require 'spec_helper'

RSpec.describe Spree::LineItem, type: :model do

  let!(:line_item) { create(:line_item) }

  let!(:destroy_data) {
    {
      name: line_item.name,
      order_number: line_item.order.number,
      sku: line_item.variant.sku,
      time: Time.current.to_i,
      user_id: line_item.order.user_id
    }
  }

  let!(:set_data) {
    {
      line_item_id: line_item.id,
      order_number: line_item.order.number,
      sku: line_item.variant.sku,
      user_id: line_item.order.user_id
    }
  }

  describe 'Callbacks' do
    it { is_expected.to callback(:create_event_on_intercom).after(:commit).if(:conditions_satisfied?) }
  end

  it 'is expected to include Spree::EventTracker' do
    expect(described_class.ancestors.include?(Spree::EventTracker)).to eq(true)
  end

  describe 'Spree::EventTracker' do
    context 'when action is create' do
      before do
        allow_any_instance_of(described_class).to receive(:action_name).and_return(:create)
        allow_any_instance_of(described_class).to receive(:create_data).and_return(set_data)
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

    context 'when action is destroy' do
      before do
        allow_any_instance_of(described_class).to receive(:action_name).and_return(:destroy)
        allow_any_instance_of(described_class).to receive(:destroy_data).and_return(destroy_data)
      end

      it_behaves_like 'event_tracker'
    end
  end

  describe '#conditions_satisfied?' do
    context 'when user_present returns true' do
      context 'when update_conditions_satisfied returns true' do
        before { allow(line_item).to receive(:update_conditions_satisfied?).and_return(true) }

        it 'is expected to return true' do
          expect(line_item.send :conditions_satisfied?).to eq(true)
        end
      end

      context 'when update_conditions_satisfied returns false' do
        before { allow(line_item).to receive(:update_conditions_satisfied?).and_return(false) }

        it 'is expected to return false' do
          expect(line_item.send :conditions_satisfied?).to eq(false)
        end
      end
    end

    context 'when user_present returns false' do
      before { allow(line_item).to receive(:user_present?).and_return(false) }

      it 'is expect to return false' do
        expect(line_item.send :conditions_satisfied?).to eq(false)
      end
    end
  end

  describe '#user_present?' do
    context 'when user is present' do
      it 'is expected to return true' do
        expect(line_item.send :user_present?).to eq(true)
      end
    end

    context 'when user is not present' do
      before {
         order = line_item.order
         order.update_column(:user_id, nil)
      }

      it 'is expected to return false' do
        expect(line_item.send :user_present?).to eq(false)
      end
    end
  end

  describe '#update_conditions_satisfied?' do
    context 'when resource is created' do
      before { allow(line_item).to receive(:resource_created?).and_return(true) }

      it 'is expected to return true' do
        expect(line_item.send :update_conditions_satisfied?).to eq(true)
      end
    end

    context 'when resource is updated' do
      before do
        allow(line_item).to receive(:resource_created?).and_return(false)
        allow(line_item).to receive(:resource_destroyed?).and_return(false)
      end

      it 'is expected to call quantity_updated_to_non_zero_value?' do
        expect(line_item).to receive(:quantity_updated_to_non_zero_value?)
        line_item.send :update_conditions_satisfied?
      end
    end

    context 'when resource is destroyed' do
      before { allow(line_item).to receive(:resource_destroyed?).and_return(true) }

      it 'is expected to return true' do
        expect(line_item.send :update_conditions_satisfied?).to eq(true)
      end
    end
  end

  describe '#quantity_updated_to_non_zero_value?' do
    context 'when quantity is changed to a non zero value' do
      before do
        allow(line_item).to receive(:saved_changes).and_return({ quantity: [1, 2] })
        allow(line_item).to receive(:saved_change_to_quantity).and_return([1, 2])
      end

      it 'is expected to return true' do
        expect(line_item.send :quantity_updated_to_non_zero_value?).to eq(true)
      end
    end

    context 'when quantity is changed to zero value' do
      before { line_item.update_column(:quantity, 0) }

      it 'is expected to return false' do
        expect(line_item.send :quantity_updated_to_non_zero_value?).to eq(false)
      end
    end
  end

  describe '#set_data' do
    it 'is expected to return a hash' do
      expect(line_item.send :set_data).to eq(set_data)
    end
  end

  describe '#create_data' do

    it 'is expected to call set_data' do
      expect(line_item).to receive(:set_data)
      line_item.send :create_data
    end
  end

  describe '#update_data' do

    it 'is expected to call set_data' do
      expect(line_item).to receive(:set_data)
      line_item.send :update_data
    end
  end

  describe '#destroy_data' do
    it 'is expected to return hash' do
      expect(line_item.send :destroy_data).to eq(destroy_data)
    end
  end

end
