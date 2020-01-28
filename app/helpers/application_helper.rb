module ApplicationHelper

  def user_has_permission_to_destroy?(item)
     return item.user == current_user && user_signed_in?
  end

end
