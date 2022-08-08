FactoryBot.define do
  factory :order_item do
    order { "" }
    sku { nil }
    quantity { 1 }
  end
end
