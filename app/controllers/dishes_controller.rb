class DishesController < ApplicationController
  before_action :redirect_user, only: [:new, :edit]
  before_action :set_restaurant, only: [:new, :create, :edit, :update]

  def new
    @dish = @restaurant.dishes.build
    
  end

  def create
    @dish = @restaurant.dishes.build(dish_params)
    if @dish.save
      redirect_to restaurant_path(@restaurant), notice: 'Prato criado com sucesso'
    else
      flash.now[:notice] = 'Prato não cadastrado'
      render :new, status: :unprocessable_entity
    end
  end

  def edit 
    @dish = @restaurant.dishes.find(params[:id])
  end

  def update
    @dish = @restaurant.dishes.find(params[:id])
    if @dish.update(dish_params)
      @dish.image.purge if params[:dish][:remove_image] == '1'
      redirect_to restaurant_path(@restaurant), notice: "Prato editado com sucesso"
    else
      flash.now[:notice] = "Prato não editado"
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def redirect_user
    if current_user != Restaurant.find(params[:restaurant_id]).user
      redirect_to root_path
    end
  end

  def dish_params 
    params.require(:dish).permit(:name, :description, :calories, :image)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
