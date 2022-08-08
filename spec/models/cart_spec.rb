require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) { Cart.new }
  describe "基本功能" do
    it "可以把商品丟到購物車，購物車就有東西" do
      cart.add_sku(1)
      #expect(cart.empty?). to be false
      expect(cart). not_to be_empty
    end

    it "相同商品在購物車不會增加，只有商品的數量增加" do

      3.times{ cart.add_sku(1) }
      2.times{ cart.add_sku(2) }

      expect(cart.items.count).to be 2
      expect(cart.items.first.quantity).to be 3
    end

    it "可以把商品放到購物車，也可以取出購物車" do
      p1 = create(:product, :with_skus)

      cart.add_sku(p1.skus.first.id)

      expect(cart.items.first.product).to be_a Product
    end

    it "可以計算整台購物車總消費金額" do
      p1 = create(:product,:with_skus, sell_price: 5)
      p2 = create(:product,:with_skus, sell_price: 10)

      3.times{ cart.add_sku(p1.skus.first.id) }
      2.times{ cart.add_sku(p2.skus.first.id) }

      expect(cart.total_price).to eq 35
    end

    it "可以把商品移出購物車" do
      3.times{ cart.add_sku(1) }
      2.times{ cart.add_sku(2) }
      cart.remove_item(1)

      expect(cart.items.count).to be 1
    end
  end

  describe '聖誕節活動' do
    it '滿千打九折' do
      p2 = create(:product, :with_skus, sell_price: 100)

      10.times{ cart.add_sku(p2.skus.first.id) }
      
      expect(cart.total_price).to eq 1000
      Timecop.freeze(DateTime.new(2022, 12, 25)) do
        expect(cart.total_price).to eq 900
      end 
    end

    it '未滿千元不打折' do
      p1 = create(:product,:with_skus,sell_price: 100)

      9.times{ cart.add_sku(p1.skus.first.id) }
      
      Timecop.freeze(DateTime.new(2022, 12, 25)) do
        expect(cart.total_price).to eq 900
      end 
    end
  end

  describe "進階功能" do
    it "將購物車內容轉換為 HASH 並存到 Session" do
      p1 = create(:product,:with_skus)
      p2 = create(:product,:with_skus)

      3.times{ cart.add_sku(p1.id) }
      2.times{ cart.add_sku(p2.id) }

      expect(cart.serialize).to eq cart_hash
    end

    it "可以將 Session 的 HASH 還原" do
      cart = Cart.from_hash(cart_hash)

      expect(cart.items.first.quantity).to be 3
    end

    private

    def cart_hash
      {
        "items" => [
          { "sku_id" => 1, "quantity" => 3 },
          { "sku_id" => 2, "quantity" => 2 },
        ]
      }
    end
  end
end
