require 'spec_helper'

describe Spree::AppConfiguration, type: :model do

  it { expect(Spree::Config).to have_preference(:intercom_application_id) }
  it { expect(Spree::Config.preferred_intercom_application_id_type).to eq(:string) }

  it { expect(Spree::Config).to have_preference(:intercom_access_token) }
  it { expect(Spree::Config.preferred_intercom_access_token_type).to eq(:string) }

  it { expect(Spree::Config).to have_preference(:enable_intercom) }
  it { expect(Spree::Config.enable_intercom_type).to eq(:boolean) }
  it { expect(Spree::Config.enable_intercom_default).to eq(false) }

  it 'is expected not to raise an exception when accessing intercom_application_id' do
    expect { Spree::Config.intercom_application_id }.not_to raise_error
  end

  it 'is expected not to raise an exception when accessing intercom_access_token' do
    expect { Spree::Config.intercom_access_token }.not_to raise_error
  end

  it 'is expected not to raise an exception when accessing enable_intercom' do
    expect { Spree::Config.enable_intercom }.not_to raise_error
  end

end
