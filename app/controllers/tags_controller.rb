class TagsController < ApplicationController
  def new
    @return_to = params[:return_to]
    @restaurant = Restaurant.find(Rails.application.routes.recognize_path(params[:return_to])[:restaurant_id])
    @tag = Tag.new  
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to params[:return_to], notice: 'Marcação criada com sucesso'
                                                                 
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

end