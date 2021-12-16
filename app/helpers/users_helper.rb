module UsersHelper
  def gravatar_for user, size: Settings.avatar_size
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def login_remember? user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_to user
  end

  def get_follower user
    current_user.active_relationships.find_by followed_id: user.id
  end
end
