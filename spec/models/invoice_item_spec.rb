require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  before(:each) do
    @m = Merchant.create!(FactoryBot.attributes_for(:merchant))
    @c = Customer.create!(FactoryBot.attributes_for(:customer))
    @item1 = @m.items.create!(name: 'Item 11', description: 'hello item 1', unit_price: 100)
    @item2 = @m.items.create!(name: 'Item 22', description: 'hello item 2', unit_price: 1000)
    @item3 = @m.items.create!(name: 'Item 33', description: 'hello item 3', unit_price: 500)
    @invoice = @c.invoices.create!(FactoryBot.attributes_for(:invoice))
    @ii1 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item1.id, quantity: 5, unit_price: @item1.unit_price, status: 2)
    @ii2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item2.id, quantity: 10, unit_price: @item2.unit_price, status: 2)
    @ii3 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item3.id, quantity: 15, unit_price: @item3.unit_price, status: 2)
    @m.discounts.create!(percentage: 5, quantity: 5)
    @m.discounts.create!(percentage: 10, quantity: 10)
    @m.discounts.create!(percentage: 15, quantity: 15)

  end
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  it 'only applies the correct discount' do
    expect(@ii1.discount_price).to eq 95
    expect(@ii2.discount_price).to eq 900
    expect(@ii3.discount_price).to eq 425
    @m.discounts.create!(percentage: 20, quantity: 10)
    expect(@ii2.discount_price).to eq 800
    expect(@ii3.discount_price).to eq 400
  end


  describe '.discount_revenue' do
    it 'returns total revenue with discount' do
      rev = InvoiceItem.where(invoice_id: @invoice.id).discount_revenue
      total = (95*5)+(900*10)+(425*15)
      expect(rev).to eq total
    end
  end
end
