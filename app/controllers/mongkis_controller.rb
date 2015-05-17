class MongkisController < ApplicationController
  before_action :check_login, only: [:edit, :update, :destroy]
  def index
    # get '/mongkis' mongkis_path
    # page to list all mongkis
  end

  def show
    # get '/mongkis/id'
    # page to show mongki with id
    @mongki = Mongki.find_by(_id: session[:id])
  end

  def new
    # get '/mongkis/new'
    # page to make a new mongki (signup)
    @mongki = Mongki.new
  end

  def create
    # post '/mongkis'
    # create new mongki
    @mongki = Mongki.new(mongki_params)

    if @mongki.save
      render :success
    else
      flash.now[:alert] = @mongki.errors.full_messages[0]
      render :new, errors: flash.now[:alert]
    end
  end

  def edit
    # get '/mongkis/email/edit'
    # page to edit mongki with email
    @mongki = Mongki.find_by(_id: params[:id])
  end

  def update
    # patch '/mongkis/id'
    # update mongki
    @mongki = Mongki.find_by(_id: session[:id])
    if @mongki && @mongki.authenticate(params[:mongki][:password_before])
      @mongki.update(name: params[:mongki][:name])
      @mongki.update(password: params[:mongki][:password])
      @mongki.update(password_confirmation: params[:mongki][:password_confirmation])
      if @mongki.save
        flash.now[:success] = "저장 완료."
        render :edit, success: flash.now[:success]
      else
        flash.now[:alert] = @mongki.errors.full_messages[0]
        render :edit, errors: flash.now[:alert]
      end
    else
      flash.now[:alert] = "패스워드가 일치하지 않습니다."
      render :edit, errors: flash.now[:alert]
    end
  end

  def destroy
    # delete '/mongkis/id'
    # delete mongki

    
  end

  private
  def mongki_params
    params.require(:mongki).permit(:email, :name, :password, :password_confirmation)
  end
end
