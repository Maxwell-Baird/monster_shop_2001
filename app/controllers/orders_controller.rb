class OrdersController <ApplicationController

  def new

  end

  def show
    @order = Order.find(params[:id])
    return update_status if @order.item_orders.all? {|item_order| item_order.status == "Fulfilled"}
  end

  def create
    order = current_user.orders.new(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:notice] = "Order Succesfully Created"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def update_status
    @order.update(status: "Packaged")
  end
end