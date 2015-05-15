module LoginHelper

  $mongki_salt = "$2a$10$aGARh1SybUDrPWsyAGIh9u"

  def logged_in?
    not session[:email].nil?
  end
end
