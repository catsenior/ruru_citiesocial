class Vendor < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true
  scope :available, -> {where(online:true)}
end
