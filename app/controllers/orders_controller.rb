class OrdersController < ApplicationController
  before_action :authenticate_user!
  def index
    @orders = current_user.orders.order(id: :desc)
  end

  def create
    @order = current_user.orders.build(order_params)

    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
    end

    if @order.save
      linepay = LinepayService.new('/v3/payments/request')
      linepay.perform({
        amount: current_cart.total_price.to_i,
        currency: 'TWD',
        orderId: @order.num,
        packages: [
          {
            id: @order.num,
            amount: @order.total_price.to_i,
            name: 'ruru_citiesocial',
            products: products_hash(@order)
          }
        ],
        redirectUrls: {
          confirmUrl: "http://35.229.146.105/orders/confirm",
          cancelUrl: "http://35.229.146.105/orders/cancel"
        }
      })

      if linepay.success?
        redirect_to linepay.payment_url
      else
        puts @result
        flash[:notice] = '付款發生錯誤'
        render 'carts/checkout'
      end
    end
  end

  def confirm
    linepay = LinepayService.new("/v3/payments/#{params[:transactionId]}/confirm")
    linepay.perform({
      amount: current_cart.total_price.to_i,
      currency: "TWD"
    })

    if linepay.success?
      # 變更訂單狀態
      order = current_user.orders.find_by(num: linepay.order[:order_id])
      order.pay!(transaction_id: linepay.order[:transaction_id])
      #清空購物車
      session[:session_cart] = nil
      redirect_to root_path, notice: '已完成付款'
    else
      redirect_to root_path, notice: '付款發生錯誤'
    end
  end

  def cancel
    @order = current_user.orders.find(params[:id])

    if @order.paid?

      linepay = LinepayService.new("/v3/payments/#{@order.transaction_id}/refund")
      linepay.perform(refundAmount: @order.total_price.to_i)

      if linepay.success?
        @order.cancel!
        redirect_to orders_path, notice: "訂單#{@order.num} 已取消，並完成退款! "
      else
        redirect_to orders_path, notice: "訂單#{@order.num} 退款發生錯誤! "
      end
    else
      @order.cancel!
      redirect_to orders_path, notice: "訂單#{@order.num} 已取消! "
    end
  end

  def pay
    @order = current_user.orders.find(params[:id])

    linepay = LinepayService.new('/v3/payments/request')
    linepay.perform({
      amount: @order.total_price.to_i,
      currency: 'TWD',
      orderId: @order.num,
      packages: [
        {
          id: @order.num,
          amount: @order.total_price.to_i,
          name: 'ruru_citiesocial',
          products: products_hash(@order)
        }
      ],
      redirectUrls: {
        confirmUrl: "http://35.229.146.105/orders/#{@order.id}/pay_confirm",
        cancelUrl: "http://35.229.146.105/orders/cancel"
      }
    })

    if linepay.success?
      redirect_to linepay.payment_url
    else
      redirect_to orders_path, notice: '付款發生錯誤'
    end
  end

  def pay_confirm
    @order = current_user.orders.find(params[:id])

    linepay = LinepayService.new("/v3/payments/#{params[:transactionId]}/confirm")
    linepay.perform({
      amount: @order.total_price.to_i,
      currency: "TWD"
    })

    if linepay.success?
      @order.pay!(transaction_id: linepay.order[:transaction_id])
      redirect_to orders_path, notice: '付款已完成'
    else
      redirect_to orders_path, notice: '付款發生錯誤'
    end
  end

  private
  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end

  def products_hash(order)
    order.order_items.map {|item|{ "name" => item.sku.product.name + "-" + item.sku.spec,
                                              "quantity" => item.quantity,
                                              "price" => item.sku.product.sell_price.to_i
                                            } } 
  end
end
