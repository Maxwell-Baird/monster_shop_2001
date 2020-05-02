class UserOrdersController < ApplicationController

  def index
  end

  def destroy
    order = Order.find(params[:order_id])
    order.update(status: "Cancelled")
    if order.save
      order.item_orders.each do |item_order|
        item = Item.find(item_order.item_id)
        item.inventory += item_order.quantity
        item.save
        item_order.update(status: "Unfulfilled")
        item_order.save
      end
      flash[:success] = "Your order has been canceled."
      redirect_to "/profile"
    end
  end

  def show
    @order = Order.find(params[:id])
    return update_status if @order.item_orders.all? {|item_order| item_order.status == "Fulfilled"}
  end

  def create
    order = current_user.orders.new(order_params)
    if order.save
      cart.items.each do |item,quantity|
        if cart.discount(item.id) != 0
          price = item.price - item.price * cart.discount(item.id)
        else
          price = item.price
        end
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: price
          })
      end
      session.delete(:cart)
      flash[:success] = "Order Succesfully Created"
      redirect_to "/profile/orders"
    else
      flash[:success] = "Please complete address form to create an order."
      render :new
    end
  end


  private

  def update_status
    @order.update(status: "Packaged")
  end

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
