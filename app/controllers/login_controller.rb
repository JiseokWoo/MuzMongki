class LoginController < ApplicationController
  def new
    # get '/login' login_path
    # page for login
    if not logged_in?
      reset_session
    else
      redirect_to root_path
    end
  end

  def create
    # post '/login' login_path
    # create new session (login)
    @mongki = Mongki.find_by(email: params[:login][:email])

    if @mongki && @mongki.authenticate(params[:login][:password])
      reset_session
      session[:id] = @mongki._id.to_s
      redirect_to root_path
    else
      flash.now[:alert] = "이메일 혹은 패스워드가 일치하지 않습니다."
      render :new, errors: flash.now[:alert]
    end
  end

  def destroy
    # delete '/logout' logout_path
    # delete session (logout)
    reset_session
    redirect_to root_path
  end
end
