require 'spec_helper'

RSpec.describe Spree::Intercom::TrackEventsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:name) { 'controller_action' }
  let!(:options) { { key: 'value' } }

  subject(:job) { described_class.perform_later(name, options) }

  it 'is expected to queue the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is expected to be in default queue' do
    expect(Spree::Intercom::TrackEventsJob.new.queue_name).to eq('default')
  end

  describe '#perform' do
    class TestService; end

    let!(:service) { TestService.new }
    let!(:intercom_service_mapper) { { controller: { action: TestService  } } }

    before do
      stub_const('INTERCOM_SERVICE_MAPPER', intercom_service_mapper )
      allow(TestService).to receive(:new).with(options).and_return(service)
      allow(service).to receive(:register).and_return(true)
    end

    it 'is expected to execute enqueue service' do
      expect(TestService).to receive(:new).with(options).and_return(service)
      perform_enqueued_jobs { job }
    end

    it 'is expected to call register' do
      expect(service).to receive(:register).and_return(true)
      perform_enqueued_jobs { job }
    end

    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end
  end
  
end
