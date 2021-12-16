class FollowerController < ApplicationController
  before_action :logged_in_user, only: :show

  def show
    @title = t "followers"
    @user = current_user
    @pagy, @users = pagy @user.followers, items: Settings.item_in_page
    render "users/show_follow"
  end
end
