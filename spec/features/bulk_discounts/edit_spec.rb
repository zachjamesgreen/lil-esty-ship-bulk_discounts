require 'rails_helper'

RSpec.describe 'Bulk Discount Edit' do
  before(:each) do
    @merchant = Merchant.create!(name: 'Holla Back')

    @discount1 = @merchant.discounts.create!(percentage: 5, quantity: 5)
    @discount2 = @merchant.discounts.create!(percentage: 10, quantity: 10)
    @discount3 = @merchant.discounts.create!(percentage: 15, quantity: 15)
    @discount4 = @merchant.discounts.create!(percentage: 20, quantity: 20)
    @discounts = [@discount1,@discount2,@discount3,@discount4]
  end

  it 'edits discount' do
    visit edit_merchant_bulk_discount_path(@discount1.merchant_id, @discount1.id)
    within 'form' do
      expect(page).to have_field('Percentage', with: @discount1.percentage)
      expect(page).to have_field('Quantity', with: @discount1.quantity)
      fill_in 'Percentage', with: 99
      fill_in 'Quantity', with: 1000
      click_on 'commit'
    end

    d = BulkDiscount.find @discount1.id
    expect(page).to have_current_path(merchant_bulk_discount_path(d.merchant_id, d.id))
    expect(d.percentage).to eq 99
    expect(d.quantity).to eq 1000

  end

end