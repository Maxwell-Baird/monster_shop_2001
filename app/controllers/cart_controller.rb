class CartController < ApplicationController
  before_action :current_user_admin?

  def show
    @items = cart.items
  end

  def destroy
    session.delete(:cart)
    redirect_to '/cart'
  end


  private

  def current_user_admin?
    render file: "/public/404" if current_user.admin?
  end
end
