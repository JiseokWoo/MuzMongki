module LoginHelper

  $mongki_salt = "$2a$10$aGARh1SybUDrPWsyAGIh9u"

  def logged_in?
    not session[:id].nil?
  end

  def check_login
    unless logged_in?
      render :'login/please_login'
    end
    unless authed_email?
      # TODO : email 인증
    end
  end

  def authed_email?
    if logged_in?
      @mongki = Mongki.find_by(id: session[:id])
      if @mongki
        @mongki.email_confirm?
      end
    end
  end
end
