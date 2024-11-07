class TagsController < ApplicationController
  def new
    @return_to = params[:return_to]
    #@restaurant = Restaurant.find(Rails.application.routes.recognize_path(params[:return_to])[:restaurant_id])
    @restaurant = Restaurant.find(params[:restaurant_id])
    @tag = Tag.new  
  end

  def create
    #@restaurant = Restaurant.find(Rails.application.routes.recognize_path(params[:return_to])[:restaurant_id])
    @restaurant = Restaurant.find(params[:restaurant_id])
    @tag = @restaurant.tags.build(tag_params)
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