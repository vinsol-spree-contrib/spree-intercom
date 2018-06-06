require 'spec_helper'

describe Spree::ProductsController, type: :controller do

  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:searcher) { Spree::Config.searcher_class.new({ key: 'value' }) }

  let!(:index_data) {
    {
      filter: 'filter',
      keyword: 'keyword',
      taxon_id: 2,
      time: Time.current.to_i,
      user_id: user.id
    }
  }

  let!(:show_data) {
    {
      product_id: product.id,
      time: Time.current.to_i,
      user_id: user.id
    }
  }

  it 'is expected to include Spree::EventTrackerController' do
    expect(controller.class.ancestors.include?(Spree::EventTrackerController)).to eq(true)
  end

  describe 'Spree::EventTrackerController' do
    context 'when action is index' do
      before do
        allow(controller).to receive(:action_name).and_return(:index)
        allow(controller).to receive(:index_data).and_return(index_data)
      end

      it_behaves_like 'event_tracker_controller'
    end

    context 'when action is show' do
      before do
        allow(controller).to receive(:action_name).and_return(:show)
        allow(controller).to receive(:show_data).and_return(show_data)
      end

      it_behaves_like 'event_tracker_controller'
    end
  end

  before do
    allow(controller).to receive(:spree_current_user).and_return(user)
    controller.instance_variable_set(:@searcher, searcher)
    allow(controller).to receive(:@searcher).and_return(searcher)
    allow(searcher).to receive(:search).and_return(searcher)
    allow(searcher).to receive(:to_s).and_return('filter')
  end

  it { is_expected.to use_after_action(:create_event_on_intercom) }

  describe '#show_data' do

    before { controller.instance_variable_set(:@product, product) }

    it 'is expected to return hash' do
      expect(controller.send :show_data).to eq(show_data)
    end
  end

  describe '#index_data' do
    before { allow(controller).to receive(:params).and_return({ keywords: 'keyword', taxon: 2 }) }

    it 'is expected to return hash' do
      expect(controller.send :index_data).to eq(index_data)
    end
  end

  describe '#product_search_conditions_satisfied?' do
    context 'when action is index' do
      before do
        allow(controller).to receive(:action_name).and_return('index')
      end

      context 'when search keyword is present' do
        before do
          allow(controller).to receive(:params).and_return({ keywords: 'keyword' })
        end

        it 'is expected to return true' do
          expect(controller.send :product_search_conditions_satisfied?).to eq(true)
        end
      end

      context 'when search keyword is not present' do
        before do
          allow(controller).to receive(:params).and_return({ key: 'value' })
          allow(searcher).to receive(:search).and_return(nil)
        end

        it 'is expected to return false' do
          expect(controller.send :product_search_conditions_satisfied?).to eq(false)
        end
      end
    end

    context 'when searcher is present' do
      before do
        allow(controller).to receive(:action_name).and_return('index')
        allow(controller).to receive(:params).and_return({ key: 'value' })
      end

      it 'is expected to return true' do
        expect(controller.send :product_search_conditions_satisfied?).to eq(true)
      end
    end

    context 'when searcher is not present' do
      before do
        allow(controller).to receive(:action_name).and_return('index')
        allow(controller).to receive(:params).and_return({ key: 'value' })
        allow(searcher).to receive(:search).and_return(nil)
      end

      it 'is expected to return false' do
        expect(controller.send :product_search_conditions_satisfied?).to eq(false)
      end
    end

    context 'when action is not index' do
      before do
        allow(controller).to receive(:action_name).and_return('not_index')
      end

      it 'is expected to return true' do
        expect(controller.send :product_search_conditions_satisfied?).to eq(true)
      end
    end
  end

end
