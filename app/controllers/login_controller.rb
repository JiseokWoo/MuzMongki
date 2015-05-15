class LoginController < ApplicationController
  def new
    # get '/login' login_path
    # page for login
    reset_session
  end

  def create
    # post '/login' login_path
    # create new session (login)
    mongki = Mongki.find_by(email: params[:login][:email])

    if mongki && mongki.authenticate(params[:login][:password])
      session[:email] = mongki.email
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid Email Address or Password!"
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
