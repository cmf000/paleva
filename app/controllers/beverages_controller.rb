class BeveragesController < ApplicationController
  before_action :redirect_user, only: [:new, :create, :edit, :update, :toggle_status, :show]
  before_action :set_restaurant, only: [:new, :create, :edit, :update, :toggle_status]

  def new
    @beverage = @restaurant.beverages.build
    @tags = @restaurant.tags
  end

  def create
    @beverage = @restaurant.beverages.build(beverage_params)
    if @beverage.save
      redirect_to restaurant_path(@restaurant), notice: 'Bebida criada com sucesso'
    else
      flash.now[:notice] = 'Bebida não cadastrada'
      @tags = Tag.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit 
    @beverage = @restaurant.beverages.find(params[:id])
    @tags = @restaurant.tags
  end

  def update
    @beverage = @restaurant.beverages.find(params[:id])
    if @beverage.update(beverage_params)
      @beverage.image.purge if params[:beverage][:remove_image] == '1'
      redirect_to restaurant_path(@restaurant), notice: "Bebida editada com sucesso"
    else
      flash.now[:notice] = "Bebida não editada"
      @tags = Tag.all
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @restaurant = Restaurant.find(params[:restaurant_id])
    @beverage = Beverage.find(params[:id])
  end

  def toggle_status
    @beverage = Beverage.find(params[:id])
    if @beverage.active?
      @beverage.update(status: :inactive)
    else
      @beverage.update(status: :active)
    end
    redirect_to restaurant_path(@restaurant.id)
  end

  private
  def redirect_user
    if current_user != Restaurant.find(params[:restaurant_id]).owner
      redirect_to root_path
    end
  end

  def beverage_params 
    params.require(:beverage).permit(:name, :description, :calories, :alcoholic, :remove_image, tag_ids: [])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
