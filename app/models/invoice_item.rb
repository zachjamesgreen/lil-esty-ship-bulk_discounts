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
    all.map do |invoice_item|
      invoice_item.quantity * invoice_item.discount_price
    end.sum
  end

  def discount_price
    price = item.unit_price
    item.merchant.discounts.order(percentage: :desc, quantity: :desc).each do |discount|
      if quantity >= discount.quantity
        percent = discount.percentage/100.to_f
        price = price - (percent * item.unit_price)
        break
      end
    end
    price
  end

  def discount
    discounts = item.merchant.discounts.order(percentage: :desc, quantity: :desc)
    return nil if discounts.size == 0
    discounts.each do |discount|
      if quantity >= discount.quantity
        return discount
      end
    end
    nil
  end
end
# m = Merchant.find 15
# ii = m.invoices.first.invoice_items.first
# ii.discount