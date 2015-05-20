class MongkisController < ApplicationController
  include MongkisHelper
  before_action :check_login, only: [:edit, :update, :destroy, :auth]

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
        if validate_name(params[:mongki][:name])
          result = @mongki.update_attribute(:name, params[:mongki][:name])
        else
          flash.now[:alert] = "Name 은 영문 알파벳, 숫자, -, _ 조합으로 3자 이상 15자 이하여야 합니다."
          render :edit, errors: flash.now[:alert]
        end
      else not(params[:mongki][:password].nil? and params[:mongki][:password_confirmation].nil?)
        result = @mongki.update_attributes(name: params[:mongki][:name], password: params[:mongki][:password], password_confirmation: params[:mongki][:password_confirmation])
      end

      if not params[:mongki][:avatar].nil? && result
        if not @mongki.avatar.url.nil?
          @mongki.avatar.remove!
        end
        update?(@mongki.update_attribute(:avatar, params[:mongki][:avatar]))
      else
        update?(result)
      end

    end
  end

  def destroy
    # delete '/mongkis/id'
    # delete mongki
    @mongki = Mongki.find_by(_id: params[:id])

    if @mongki && @mongki.destroy
      reset_session
      render :destroy_success
    else
      render :destroy_fail
    end
  end

  def auth
    if Mongki.authenticate(session[:id], params[:mongki][:password])
      redirect_to edit_mongki_path(session[:id])
    else
      flash.now[:alert] = "패스워드가 일치하지 않습니다."
      render :auth, errors: flash.now[:alert]
    end
  end

  private
  def mongki_params
    params.require(:mongki).permit(:email, :name, :password, :password_confirmation, :avatar)
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
