class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.page(params[:page]).per(Settings.pagination.items)
  end

  def new
    @user = User.new
  end

  def show; end
  
  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "mailer.check_you_email"
      redirect_to root_url
    else
      flash[:fail] = t "errors.the_form_contains"
      render :new
    end
  end

  def edit; end
  
  def update
    if @user.update_attributes user_params
      flash[:success] = t "static_pages.update_profile"
      redirect_to @user
    else
      flash[:fail] = t "static_pages.update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "static_pages.user_delete"
      redirect_to users_url
    else
      flash[:fail] = t "static_pages.delete_fail"
      redirect_to users_url
    end
  end
  
  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "auth.please_login"
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user
    
    redirect_to root_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:error] = t "errors.user"
    redirect_to root_url
  end
end
