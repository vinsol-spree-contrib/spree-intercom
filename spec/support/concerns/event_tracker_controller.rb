require 'spec_helper'

RSpec.shared_examples 'event_tracker_controller' do

  let!(:user) { create(:user) }

  it 'is expected to extend ActiveSupport::Concern' do
    expect(Spree::EventTrackerController.singleton_class.ancestors.include?(ActiveSupport::Concern)).to eq(true)
  end

  describe '#create_event_on_intercom' do
    before { ActiveJob::Base.queue_adapter = :test }

    context 'when user_present returns true' do
      before { allow(controller).to receive(:user_present?).and_return(true) }

      it 'is expected to enqueue TrackEventsJob' do
        expect {
          controller.send :create_event_on_intercom
        }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
      end

    end

    context 'when user_present returns false' do
      before { allow(controller).to receive(:user_present?).and_return(false) }

      it 'is expected to enqueue TrackEventsJob' do
        expect {
          controller.send :create_event_on_intercom
        }.not_to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }
      end
    end

    describe '#user_present?' do
      context 'when user is present' do
        before { allow(controller).to receive(:spree_current_user).and_return(user) }

        it 'is expected to return true' do
          expect(controller.send :user_present?).to eq(true)
        end
      end

      context 'when user is not present' do
        before { allow(controller).to receive(:spree_current_user).and_return(nil) }

        context 'when user is logged out' do
          before { allow(controller).to receive(:user_logged_out?).and_return(true) }

          it 'is expected to return true' do
            expect(controller.send :user_present?).to eq(true)
          end
        end

        context 'when user is not logged out' do
          before { allow(controller).to receive(:user_logged_out?).and_return(false) }

          it 'is expected to return false' do
            expect(controller.send :user_present?).to eq(false)
          end
        end
      end
    end

    describe '#user_logged_out?' do
      context 'when controller is user_sessions' do
        before do
          allow(controller).to receive(:controller_name).and_return('user_sessions')
        end

        context 'when action is destroy' do
          before do
            allow(controller).to receive(:action_name).and_return('destroy')
          end

          it 'is expected to return true' do
            expect(controller.send :user_logged_out?).to eq(true)
          end
        end

        context 'when action is not destroy' do
          before do
            allow(controller).to receive(:action_name).and_return('not_destroy')
          end

          it 'is expected to return false' do
            expect(controller.send :user_logged_out?).to eq(false)
          end
        end
      end

      context 'when controller is not user_sessions' do
        before do
          allow(controller).to receive(:controller_name).and_return('user_sessions')
        end

        it 'is expected to return false' do
          expect(controller.send :user_logged_out?).to eq(false)
        end
      end
    end
  end
end
