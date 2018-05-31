require 'spec_helper'

RSpec.shared_examples 'event_tracker_controller' do

  it 'is expected to extend ActiveSupport::Concern' do
    expect(Spree::EventTrackerController.ancestors.include?(ActiveSupport::Concern)).to eq(true)
  end

  describe '#create_event_on_intercom' do
    context 'when user_present returns true' do
      before {
        ActiveJob::Base.queue_adapter = :test
        allow(controller).to receive(:user_present?).and_return(true)
      }

      it 'is expected to enqueue TrackEventsJob' do
        expect {
          controller.send :create_event_on_intercom
        }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
      end

    end

    context 'when user_present returns false' do

    end
  end
end
