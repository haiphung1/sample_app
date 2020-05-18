class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:error] = t "errors.user"
    redirect_to root_url
  end
  
  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "welcome"
      redirect_to root_url
    else
      flash[:fail] = t "errors.the_form_contains"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end
end
