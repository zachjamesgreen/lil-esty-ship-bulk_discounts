class BulkDiscountsController < ApplicationController
  def index
    require "pry"; binding.pry
    @discounts = BulkDiscount.find_by_merchant_id(params[:merchant_id])
  end
end