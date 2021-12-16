module UsersHelper
  def gravatar_for user
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def login_remember? user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_to user
  end
end
