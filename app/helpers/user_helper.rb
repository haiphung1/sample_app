module UserHelper
  def gravatar_for user
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end
  
  def unfollow
    current_user.active_relationships.find_by followed_id: @user.id
  end
end
