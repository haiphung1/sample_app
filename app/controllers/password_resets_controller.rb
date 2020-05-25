class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "mailer.password_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t "mailer.email_fail"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      flash[:danger] = t "mailer.password_error"
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "mailer.successful_reset"
      redirect_to @user
    else
      flash[:danger] = t "errors.password_failed"
      render :edit
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
  end

  def user_params
    params.require(:user).permit User::PASSWORD_PARAMS
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    
    flash[:danger] = t "not_found"
    redirect_to root_url
  end
end
