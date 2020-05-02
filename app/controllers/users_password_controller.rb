class UsersPasswordController < ApplicationController

  def edit
  end

  def update
    user = User.find(current_user.id)
    if params[:password] == params[:confirmation]
      user.password = params[:password]
      if params[:password] == ''
        flash[:error] = 'Your password is blank.'
        render :edit
      elsif user.save
        flash[:success] = 'Your password has been updated.'
        redirect_to '/profile'
      end
    else
      flash[:error] = 'Your password and confirm password do not match.'
      render :edit
    end
  end
end
