require 'spec_helper'

describe Spree::UserSessionsController, type: :controller do

  it { is_expected.to use_after_action(:shutdown_intercom) }

  describe '#shutdown_intercom' do
    before do
      subject.send :shutdown_intercom  
    end

    it 'is expected to expire intercom cookies' do
      expect(cookies["intercom-session-#{Spree::Config.intercom_application_id}"]).to eq(nil)
    end
  end


end
