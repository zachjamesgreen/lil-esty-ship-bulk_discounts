require 'rails_helper'

RSpec.describe 'Bulk Discounts Index' do
  before(:each) do
    @merchant = Merchant.create!(name: 'Holla Back')

    @discount1 = @merchant.discounts.create!(percentage: 5, quantity: 5)
    @discount1 = @merchant.discounts.create!(percentage: 10, quantity: 10)
    @discount1 = @merchant.discounts.create!(percentage: 15, quantity: 15)
    @discount1 = @merchant.discounts.create!(percentage: 20, quantity: 20)

    visit merchant_bulk_discounts_path @merchant
  end

  it 'shows all discounts for merchant' do
    @merchant.discounts.each do |d|
      expect(page).to have_content(d.id.to_s)
    end
  end
end