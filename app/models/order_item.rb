class OrderItem < ApplicationRecord
  belongs_to :sku
  belongs_to :order

  def total_price
    quantity * sku.product.sell_price
  end
end
