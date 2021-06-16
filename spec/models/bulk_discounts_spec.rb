require 'rails_helper'

describe BulkDiscount do
  describe "validations" do
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of :percentage }
    it { should validate_numericality_of :quantity }
  end
  describe "relationships" do
    it { should belong_to :merchant }

  end
end