class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.all, items: Settings.item_in_page
  end

  def show
    @pagy, @microposts = pagy @user.microposts, items: Settings.item_in_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_mail_activate
      flash[:success] = t "mail.success"
      redirect_to root_path
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.edit.success"
      redirect_to @user
    else
      flash[:danger] = t "danger"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.delete_done"
    else
      flash[:danger] = t "users.delete_fail"
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit User::PROPERTIES
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user? @user
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "danger"
    redirect_to help_url
  end
end
