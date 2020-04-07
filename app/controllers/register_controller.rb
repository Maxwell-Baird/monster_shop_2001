class RegisterController < ApplicationController

  def new
  end

  def create
    @user = User.new(user_params)
    if User.exists?(email: user_params[:email])
      flash[:error] = "Email already in use. Try a different email."
      render :new
    elsif @user.save && params[:confirm_pass] == params[:password]
      flash[:notice] = "Your account has been created."
      redirect_to "/profile"
    else
      flash[:error] = "Unable to create account: Required information missing."
      redirect_to request.referer
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :confirm_pass)
  end
end
