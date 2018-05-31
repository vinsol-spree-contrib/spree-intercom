require 'spec_helper'

describe Spree::TaxonsController, type: :controller do

  before do
    allow(controller).to receive(:spree_current_user).and_return(user)
  end

  let!(:user) { create(:user) }

  it { is_expected.to use_after_action(:create_event_on_intercom) }

  describe '#show_data' do
    let!(:show_data) {
      {
        filter: 'filter',
        taxon: 'spree',
        time: Time.current.to_i,
        user_id: user.id
      }
    }

    let!(:searcher) { Spree::Config.searcher_class.new({ key: 'value' }) }

    before do
      controller.instance_variable_set(:@searcher, searcher)
      allow(controller).to receive(:@searcher).and_return(searcher)
      allow(searcher).receive(:search).and_return(searcher)
      allow(searcher).receive(:to_s).and_return('filter')
    end

    it 'is expected to return hash' do
      expect(controller.send :show_data).to eq(show_data)
    end
  end

end
