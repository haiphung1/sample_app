class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user_followed, only: :create
  before_action :user_followed, only: :destroy

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private

  def find_user_followed
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:error] = t "errors.user"
    redirect_to @user
  end

  def user_followed
    @user = Relationship.find_by(id: params[:id]).followed
    return if @user

    flash[:error] = t "errors.user"
    redirect_to @user
  end
end
