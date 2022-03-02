require 'rails_helper'

RSpec.describe "Ordering function", type: :model do
  let!(:user1){FactoryBot.create(:user)}
  let!(:user2){FactoryBot.create(:second_user)}
  let!(:item){FactoryBot.create(:item)}

  context "If two users order 5 units of the same product at the same time" do
    before do
      threads = []
      threads << Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          order = Order.create(user_id: user1.id)
          ordered_list = OrderedList.create(order_id: order.id, item_id: item.id, quantity: 5)
          order.update_total_quantity
        end
      end
      threads << Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          order = Order.create(user_id: user2.id)
          ordered_list = OrderedList.create(order_id: order.id, item_id: item.id, quantity: 5)
          order.update_total_quantity
        end
      end
      threads.each(&:join)
    end
    it "The total number of orders for that product must be 10." do
      expect(item.reload.total_quantity).to eq(5 + 5)
    end
  end
end
