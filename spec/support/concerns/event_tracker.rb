require 'spec_helper'

RSpec.shared_examples 'event_tracker' do

  let!(:resource) { create(described_class.name.demodulize.underscore.to_sym) }

  it 'is expected to extend ActiveSupport::Concern' do
    expect(Spree::EventTracker.singleton_class.ancestors.include?(ActiveSupport::Concern)).to eq(true)
  end

  describe '#create_event_on_intercom' do
    before { ActiveJob::Base.queue_adapter = :test }

    context 'when user_present returns true' do
      it 'is expected to enqueue TrackEventsJob' do
        expect {
          resource.send :create_event_on_intercom
        }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
      end
    end
  end

  describe '#action_name' do
    let!(:order) { create(:order, state: 'cart') }

    context 'when resource is order' do
      context 'when order state is complete' do
        before do
          allow(order).to receive(:action_name).and_call_original
          order.update_column(:state, :complete)
        end

        it 'is expected to return placed' do
          expect(order.send :action_name).to eq(:placed)
        end
      end

      context 'when order state is not complete' do
        before do
          allow(order).to receive(:action_name).and_call_original
        end

        it 'is expected to return update' do
          expect(order.send :action_name).to eq(:update)
        end
      end
    end

    context 'when resource is not order' do

      context 'when resource is created' do
        before do
          allow(resource).to receive(:action_name).and_call_original
          allow(resource).to receive(:resource_created?).and_return(true)
        end

        it 'is expected to return create' do
          skip if resource.is_a?(Spree::Order)
          expect(resource.send :action_name).to eq(:create)
        end
      end

      context 'when resource is updated' do
        before do
          allow(resource).to receive(:action_name).and_call_original
          allow(resource).to receive(:resource_created?).and_return(false)
          allow(resource).to receive(:resource_updated?).and_return(true)
        end

        it 'is expected to return update' do
          skip if resource.is_a?(Spree::Order)
          expect(resource.send :action_name).to eq(:update)
        end
      end

      context 'when resource is destroyed' do
        before do
          allow(resource).to receive(:action_name).and_call_original
          allow(resource).to receive(:resource_created?).and_return(false)
          allow(resource).to receive(:resource_updated?).and_return(false)
          allow(resource).to receive(:resource_destroyed?).and_return(true)
        end

        it 'is expected to return destroy' do
          skip if resource.is_a?(Spree::Order)
          expect(resource.send :action_name).to eq(:destroy)
        end
      end
    end
  end

  describe '#resource_created?' do
    context 'when resource is persisted' do
      context 'when resource has create transaction' do
        before do
          allow(resource).to receive(:transaction_include_any_action?).with([:create]).and_return(true)
        end

        it 'is expected to return true' do
          expect(resource.send :resource_created?).to eq(true)
        end
      end

      context 'when resource does not have created' do
        before do
          allow(resource).to receive(:transaction_include_any_action?).with([:create]).and_return(false)
        end

        it 'is expected to return false' do
          expect(resource.send :resource_created?).to eq(false)
        end
      end
    end

    context 'when resource is not persisted' do
      before do
        resource.delete
      end

      it 'is expected to return false' do
        expect(resource.send :resource_created?).to eq(false)
      end
    end
  end

  describe '#resource_updated?' do
    context 'when resource is persisted' do
      context 'when resource has create transaction' do
        before do
          allow(resource).to receive(:transaction_include_any_action?).with([:update]).and_return(true)
        end

        it 'is expected to return true' do
          expect(resource.send :resource_updated?).to eq(true)
        end
      end

      context 'when resource does not have updated' do
        before do
          allow(resource).to receive(:transaction_include_any_action?).with([:update]).and_return(false)
        end

        it 'is expected to return false' do
          expect(resource.send :resource_updated?).to eq(false)
        end
      end
    end

    context 'when resource is not persisted' do
      before do
        resource.delete
      end

      it 'is expected to return false' do
        expect(resource.send :resource_updated?).to eq(false)
      end
    end
  end

  describe '#resource_destroyed?' do
    context 'when resource is persisted' do
      it 'is expected to return false' do
        expect(resource.send :resource_destroyed?).to eq(false)
      end
    end

    context 'when resource is not persisted' do
      before do
        resource.delete
      end

      it 'is expected to return true' do
        expect(resource.send :resource_destroyed?).to eq(true)
      end
    end
  end

end
