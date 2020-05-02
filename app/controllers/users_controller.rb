class UsersController < ApplicationController

  def edit
  end

  def update
    if !existing_email?
      current_user.update(user_params)
      if current_user.save
        flash[:notice] = "Your information has successfully been updated."
        redirect_to "/profile"
      else
        flash[:error] = current_user.errors.full_messages.to_sentence
        render :edit
      end
    else
      flash[:error] = "That email is already in use."
      render :edit
    end
  end


  private

  def existing_email?
    User.exists?(email: params[:email]) && params[:email] != current_user.email
  end

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email)
  end
end
