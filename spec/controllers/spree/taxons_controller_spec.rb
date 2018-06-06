require 'spec_helper'

describe Spree::TaxonsController, type: :controller do

  before do
    allow(controller).to receive(:spree_current_user).and_return(user)
  end

  let!(:user) { create(:user) }

  let!(:show_data) {
    {
      filter: 'filter',
      taxon: 'spree',
      time: Time.current.to_i,
      user_id: user.id
    }
  }

  it 'is expected to include Spree::EventTrackerController' do
    expect(controller.class.ancestors.include?(Spree::EventTrackerController)).to eq(true)
  end

  describe 'Spree::EventTrackerController' do
    before do
      allow(controller).to receive(:action_name).and_return(:show)
      allow(controller).to receive(:show_data).and_return(show_data)
    end

    it_behaves_like 'event_tracker_controller'
  end

  it { is_expected.to use_after_action(:create_event_on_intercom) }

  describe '#show_data' do
    let!(:searcher) { Spree::Config.searcher_class.new({key: 'value'}) }

    before do
      controller.instance_variable_set(:@searcher, searcher)
      allow(controller).to receive(:@searcher).and_return(searcher)
      allow(searcher).to receive(:search).and_return(searcher)
      allow(searcher).to receive(:to_s).and_return('filter')
      allow(controller).to receive(:params).and_return({ id: 'spree' })
    end

    it 'is expected to return hash' do
      expect(controller.send :show_data).to eq(show_data)
    end
  end

end
