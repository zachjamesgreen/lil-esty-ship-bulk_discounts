require 'rails_helper'

RSpec.describe 'Bulk Discount Show' do
  before(:each) do
    @merchant = Merchant.create!(name: 'Holla Back')

    @discount1 = @merchant.discounts.create!(percentage: 5, quantity: 5)
    @discount2 = @merchant.discounts.create!(percentage: 10, quantity: 10)
    @discount3 = @merchant.discounts.create!(percentage: 15, quantity: 15)
    @discount4 = @merchant.discounts.create!(percentage: 20, quantity: 20)
  end
  it 'shows discount info' do
    visit merchant_bulk_discount_path @discount1.merchant_id, @discount1.id
    expect(page).to have_content("Percentage: #{@discount1.percentage}")
    expect(page).to have_content("Quantity: #{@discount1.quantity}")
  end
end