class DoodlesController < ApplicationController
  before_action :check_login, except: [:show]

  def new
    @doodle = Doodle.new
  end

  def create
    @doodle = Doodle.new(doodle_params)
    @doodle.owner = BSON::ObjectId.from_string(session[:id])
    @doodle.tags = doodle_params[:tag_list].scan(/#\w{2,10}/i)

    if @doodle.save
      redirect_to @doodle
    else
      flash.now[:alert] = @doodle.errors.full_messages[0]
      render :new, errors: flash.now[:alert]
    end
  end

  def show
    @doodle = Doodle.find_by(_id: params[:id])
  end

  def edit
    @doodle = Doodle.find_by(_id: params[:id])
  end

  def update
    @doodle = Doodle.find_by(id: params[:id])

    if @doodle
      tag_list = params[:doodle][:tags].scan(/#\w{2,10}/i)
      if @doodle.update_attributes(title: params[:doodle][:title], contents: params[:doodle][:contents], tags: tag_list)
        flash.now[:success] = "저장 완료."
        render :show, success: flash.now[:success]
      else
        flash.now[:alert] = @doodle.errors.full_messages[0]
        render :edit, errors: flash.now[:alert]
      end
    end
  end

  def destroy
    @doodle = Doodle.find_by(_id: params[:id])

    if @doodle && @doodle.delete
      render :destroy_success
    else
      render :destroy_fail
    end
  end

  private
  def doodle_params
    params.require(:doodle).permit(:title, :contents, :tag_list)
  end
end
