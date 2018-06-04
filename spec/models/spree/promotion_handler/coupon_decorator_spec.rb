require 'spec_helper'

RSpec.describe Spree::PromotionHandler::Coupon, type: :model do

  let!(:order) { create(:order) }
  let!(:coupon) { Spree::PromotionHandler::Coupon.new(order) }

  describe '#set_success_code' do
    before { ActiveJob::Base.queue_adapter = :test }

    it 'is expected to enqueue track events job' do
      expect { coupon.set_success_code('status') }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
    end
  end

  describe '#create_data' do
    let!(:create_data) {
      {
        code: order.coupon_code,
        order_id: order.id,
        time: Time.current.to_i,
        user_id: order.user_id
      }
    }

    it 'is expected to return hash' do
      expect(coupon.send :create_data).to eq(create_data)
    end
  end
end
