class UserOrdersController < ApplicationController
  def index
  end

  def cancel
    order = Order.find(params[:order_id])
    order.update(status: "Canceled")
    if order.save
      order.item_orders.each do |item_order|
        item = Item.find(item_order.item_id)
        item.inventory += item_order.quantity
        item.save
        item_order.update(status: "Unfulfilled")
        item_order.save
      end
      flash[:notice] = "Your order has been canceled."
      redirect_to "/profile"
    end
  end

  def show
    @order = Order.find(params[:id])
  end
end
