require 'rails_helper'

RSpec.describe Vendor, type: :model do
  context "驗證廠商名稱" do
    it "有填寫" do
      vendor = Vendor.new(name: 'Name')
      expect(vendor).to be_valid
    end
    it "沒填寫" do 
      vendor = Vendor.new
      expect(vendor).not_to be_valid
    end
  end
end
