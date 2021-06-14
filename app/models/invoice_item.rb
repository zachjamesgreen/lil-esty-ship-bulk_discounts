class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def self.discount_revenue
    all.map do |ii|
      ii.quantity * ii.discount
    end.sum
  end

  def discount
    price = item.unit_price
    item.merchant.discounts.order(quantity: :desc).each do |d|
      if quantity >= d.quantity
        percent = d.percentage/100.to_f
        price = price - (percent * item.unit_price)
        break
      end
    end
    price
  end
end
# m = Merchant.find 15
# ii = m.invoices.first.invoice_items.first
# ii.discount