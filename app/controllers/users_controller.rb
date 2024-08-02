class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.sorted_by_name, limit: Settings.page)
  end

  def show
    @page, @microposts = pagy(@user.microposts, limit: Settings.page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".message.check_email"
      redirect_to root_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".message.updated"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".message.deleted"
    else
      flash[:danger] = t ".message.delete_fail"
    end
    redirect_to users_path
  end

  def following
    @title = t ".following"
    @pagy, @users = pagy @user.following, limit: Settings.page
    render :show_follow
  end

  def followers
    @title = t ".followers"
    @pagy, @users = pagy @user.followers, limit: Settings.page
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit [:name, :email, :password,
                                 :password_confirmation]
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".message.not_found"
    redirect_to root_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t ".message.auth.edit"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t ".message.auth.delete"
    redirect_to root_path
  end
end
