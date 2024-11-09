class MenusController < ApplicationController
  before_action :set_restaurant_and_check_user_is_owner
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu = Menu.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu = @restaurant.menus.build(menu_params)

    if @menu.save
      redirect_to [@restaurant, @menu], notice: 'Cardápio criado com sucesso'
    else
      flash.now[:notice] = 'Cardápio não foi criado'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @menu = Menu.find(params[:id])
  end


  private
  def menu_params
    params.require(:menu).permit(:name)
  end

  def set_restaurant_and_check_user_is_owner
    @restaurant = Restaurant.find(params[:restaurant_id])
    if current_user != @restaurant.owner
      redirect_to root_path
    end
  end
end