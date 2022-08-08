class Product < ApplicationRecord
  include CodeGenerator
  has_rich_text :description
  has_one_attached :cover_image

  validates :code, uniqueness: true
  validates :name, presence: true
  validates :list_price, :sell_price, numericality: { greater_than: 0, allow_nil: true }
  belongs_to :category, optional: true
  belongs_to :vendor
  has_many :skus, dependent: :delete_all
  accepts_nested_attributes_for :skus, allow_destroy: true, reject_if: :all_blank
end
