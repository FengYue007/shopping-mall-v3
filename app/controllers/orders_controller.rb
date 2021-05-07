class OrdersController < ApplicationController
  before_action :authenticate_user!
  include BraintreeUtils
  include CurrentCart

  def create
    # 建立訂單
    order = current_user.orders.new(order_params)

    # 從購物車把東西拿出來 -> order item
    current_cart.line_items.each do |item|
      order.order_items.new(
        product: item.product,
        quantity: item.quantity
      )
    end

    if order.save
      # 刷卡（交易）
      result = gateway.transaction.sale(
        amount: current_cart.total_price,
        payment_method_nonce: params[:nonce],
        options: {
          submit_for_settlement: true
        }
      )

      if result.success?
        # 清購物車
        empty_cart!
        order.pay!
        redirect_to root_path, notice: "感謝大爺"
      else
        redirect_to root_path, notice: "刷卡發生錯誤"
      end

    else
      redirect_to root_path, notice: order.errors.full_messages
    end


    # 離開 -> 首頁

    # render html: params
  end

  private
    def order_params
      params.require(:order).permit(:receiver, :tel, :address)
    end
end
