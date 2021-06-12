class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find params[:merchant_id]
    @discounts = BulkDiscount.where(merchant_id: @merchant.id)
    @holidays = API.get_next_holidays[0..2]
  end

  def show
    @discount = BulkDiscount.find params[:id]
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

  def update
    d = BulkDiscount.find(params[:id])
    d.update(discount_params)
    redirect_to merchant_bulk_discount_path(d.merchant_id, d.id)
  end

  def edit
    @discount = BulkDiscount.find params[:id]
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:percentage, :quantity)
  end
end