class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find params[:merchant_id]
    @discounts = BulkDiscount.where(merchant_id: @merchant.id)
    @holidays = API.get_next_holidays[0..2]
  end

  def create
    @discount = BulkDiscount.new(
      percentage: params[:percentage],
      quantity: params[:quantity],
      merchant_id: params[:merchant_id]
    )
    flash[:notice] = @discount.save ? 'Discount Saved' : 'Discount Not Saved'
    redirect_to merchant_bulk_discounts_path
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path
  end


end