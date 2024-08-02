class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t ".message.created"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy(current_user.feed, limit: Settings.page)
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".message.deleted"
    else
      flash[:danger] = t ".message.delete_failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t ".message.invalid"
    redirect_to request.referer || root_url
  end
end
