class FollowsController < ApplicationController
  before_action :logged_in_user, :find_user
  
  def following
    @title = t "follow.following"
    @users = @user.following.page(params[:page]).per(Settings.pagination.items)
    render "users/show_follow"
  end
  
  def followers
    @title = t "follow.followers"
    @users = @user.followers.page(params[:page]).per(Settings.pagination.items)
    render "users/show_follow"
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:error] = t "errors.user"
    redirect_to root_url
  end
end
