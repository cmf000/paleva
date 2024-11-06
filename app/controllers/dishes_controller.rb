class DishesController < ApplicationController
  before_action :redirect_user, only: [:new, :create, :edit, :update, :toggle_status, :show]
  before_action :set_restaurant, only: [:new, :create, :edit, :update, :toggle_status]

  def new
    @dish = @restaurant.dishes.build
    @tags = Tag.all
  end

  def create
    @dish = @restaurant.dishes.build(dish_params)
    if @dish.save
      redirect_to restaurant_path(@restaurant), notice: 'Prato criado com sucesso'
    else
      flash.now[:notice] = 'Prato não cadastrado'
      @tags = Tag.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit 
    @dish = @restaurant.dishes.find(params[:id])
    @tags = Tag.all
  end

  def update
    @dish = @restaurant.dishes.find(params[:id])
    if @dish.update(dish_params)
      @dish.image.purge if params[:dish][:remove_image] == '1'
      redirect_to restaurant_path(@restaurant), notice: "Prato editado com sucesso"
    else
      flash.now[:notice] = "Prato não editado"
      @tags = Tag.all
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @restaurant = Restaurant.find(params[:restaurant_id])
    @dish = Dish.find(params[:id])
  end

  def toggle_status
    @dish = Dish.find(params[:id])
    if @dish.active?
      @dish.update(status: :inactive)
    else
      @dish.update(status: :active)
    end
    redirect_to restaurant_path(@restaurant.id)
  end

  private
  def redirect_user
    if current_user != Restaurant.find(params[:restaurant_id]).user
      redirect_to root_path
    end
  end

  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :image, tag_ids: [])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
