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
      render :create_success
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

    @mongki = Mongki.find_by(_id: params[:id])

    if @mongki
      if params[:mongki][:password].empty? and params[:mongki][:password_confirmation].empty?
        update?(@mongki.update_attributes(name: params[:mongki][:name]))
      else not(params[:mongki][:password].nil? and params[:mongki][:password_confirmation].nil?)
        update?(@mongki.update_attributes(name: params[:mongki][:name], password: params[:mongki][:password], password_confirmation: params[:mongki][:password_confirmation]))
      end
    end
  end

  def destroy
    # delete '/mongkis/id'
    # delete mongki
    @mongki = Mongki.find_by(_id: params[:id])

    if @mongki.delete
      reset_session
      render :destroy_success
    else
      render :destroy_fail
    end
    
  end

  private
  def mongki_params
    params.require(:mongki).permit(:email, :name, :password, :password_confirmation)
  end

  def update?(update_result)
    if update_result
      flash.now[:success] = "저장 완료."
      render :edit, success: flash.now[:success]
    else
      flash.now[:alert] = @mongki.errors.full_messages[0]
      render :edit, errors: flash.now[:alert]
    end
  end
end
