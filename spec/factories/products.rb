FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    vendor
    list_price { Faker::Number.between(from: 1, to: 99) }
    sell_price { Faker::Number.between(from: 1, to: 99)  }
    on_sell { false }
    category

    trait :with_skus do
      transient do
        amount { 2 }
      end
      skus {build_list :sku, amount }
    end
  end
end
