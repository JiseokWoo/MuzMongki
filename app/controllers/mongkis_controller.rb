class MongkisController < ApplicationController
  helper MongkisHelper
  def index
    # get '/mongkis' mongkis_path
    # page to list all mongkis
  end

  def show
    # get '/mongkis/id'
    # page to show mongki with id
    @mongki = Mongki.find_by_email(params[:email])
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
    # get '/mongkis/id/edit'
    # page to edit mongki with id
  end

  def update
    # patch '/mongkis/id'
    # update mongki
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
