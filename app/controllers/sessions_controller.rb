class SessionsController < ApplicationController

  def new
    if current_user.basic?
      flash[:success] = "You're already logged in."
      redirect_to '/profile'
    elsif current_user.merchant?
      flash[:success] = "You're already logged in."
      redirect_to '/merchant'
    elsif current_user.admin?
      flash[:success] = "You're already logged in."
      redirect_to '/admin'
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = 'You have successfully logged in.'
      if user.basic?
        redirect_to '/profile'
      elsif user.merchant?
        redirect_to '/merchant'
      elsif user.admin?
        redirect_to '/admin'
      end
    else
      flash[:error] = "Your credentials are incorrect."
      render :new
    end
  end

  def show
    session.clear
    flash[:success] = "You're logged out."
    redirect_to '/'
  end
end
