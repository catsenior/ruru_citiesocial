class Category < ApplicationRecord
  acts_as_paranoid
  acts_as_list
  default_scope { order(position: :asc) }
  validates :name, presence: true
  has_many :products
end
