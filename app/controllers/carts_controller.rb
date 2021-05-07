class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def destroy
    empty_cart!
    redirect_to root_path, notice: "購物車已清空！"
  end

  def checkout
    @order = Order.new
  end
end
