class CartItemsController < ApplicationController
  before_action :current_user_admin?

  def create
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def update
    if params[:quantity] == "inc"
      cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
    elsif params[:quantity] == "dec"
      cart.subtract_quantity(params[:item_id])
      return destroy(params[:item_id]) if cart.quantity_zero?(params[:item_id])
    end
    redirect_to "/cart"
  end

  def destroy(item = nil)
    item.nil? ? (session[:cart].delete(params[:item_id])) : session[:cart].delete(item)
    redirect_to '/cart'
  end

  private

  def current_user_admin?
    render file: "/public/404" if current_user.admin?
  end
end
