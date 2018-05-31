require 'spec_helper'

describe Spree::ProductsController, type: :controller do

  before do
    allow(controller).to receive(:spree_current_user).and_return(user)
  end

  let!(:user) { create(:user) }
  let!(:product) { create(:product) }

  it { is_expected.to use_after_action(:create_event_on_intercom) }

  describe '#show_data' do
    let!(:show_data) {
      {
        product_id: product.id,
        time: Time.current.to_i,
        user_id: user.id
      }
    }

    before { controller.instance_variable_set(:@product, product) }

    it 'is expected to return hash' do
      expect(controller.send :show_data).to eq(show_data)
    end
  end

  describe '#index_data' do
    let!(:index_data) {
      {
        search_keyword: 'keyword',
        time: Time.current.to_i,
        user_id: user.id
      }
    }

    before do
      allow(controller).to receive(:params).and_return({ keywords: 'keyword' })
    end

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
        end

        it 'is expected to return false' do
          expect(controller.send :product_search_conditions_satisfied?).to eq(false)
        end
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
