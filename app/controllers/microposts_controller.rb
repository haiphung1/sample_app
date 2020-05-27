class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t "micropost.created"
      redirect_to root_url
    else
      @feed_items = current_user.feed.page(params[:page]).per(Settings.pagination.items)
      flash[:danger] = t "micropost.faild"
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.deleted"
    else
      flash[:success] = t "micropost.delete_fail"
    end
    redirect_to request.referrer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end
end
