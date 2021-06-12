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
      expect(page).to have_content("#{d.percentage}%")
        expect(page).to have_content(d.quantity)
      expect(page).to have_link(d.id.to_s, href: merchant_bulk_discount_path(d.merchant_id, d.id))
    end
  end

  it 'creates a new discount' do
    within 'form' do
      fill_in 'percentage', with: 30
      fill_in 'quantity', with: 100
      click_on 'commit'
    end

    expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant))
    expect(page.find('.notice')).to have_content('Discount Saved')
    discount = BulkDiscount.last
    within "#discount-#{discount.id}" do
      expect(page).to have_link(discount.id.to_s, href: merchant_bulk_discount_path(discount.merchant_id, discount.id))
      expect(page).to have_content(discount.percentage)
      expect(page).to have_content(discount.quantity)
    end
  end

  it 'should not create discount with not valid input' do
    within 'form' do
      fill_in 'percentage', with: 'Not'
      fill_in 'quantity', with: 'Valid'
      click_on 'commit'
    end
    expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant))
    expect(page.find('.notice')).to have_content('Discount Not Saved')
  end

end