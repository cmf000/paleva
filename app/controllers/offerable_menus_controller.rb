class OfferableMenusController < ApplicationController
  before_action :set_restaurant_and_menu_and_check_user_is_owner

  def new
    @offerable_menu = OfferableMenu.new
    @dishes = @restaurant.dishes.where.not(id: @menu.dishes.pluck(:id))
    @beverages = @restaurant.beverages.where.not(id: @menu.beverages.pluck(:id))
  end

  def create
    @offerable_menu = @menu.offerable_menus.build(offerable_menu_params)
    if @offerable_menu.save
      redirect_to [@restaurant, @menu], notice: "Item adicionado com sucesso"
    else
      @dishes = @restaurant.dishes.active.where.not(id: @menu.dishes.pluck(:id))
      @beverages = @restaurant.beverages.active.where.not(id: @menu.beverages.pluck(:id))
      flash.now[:notice] = "Não foi possível adicionar o item"
      render :new, status: :unprocessable_entity
    end
  end


  private
  def set_restaurant_and_menu_and_check_user_is_owner
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu = Menu.find(params[:menu_id])
    if current_user != @restaurant.owner
      redirect_to root_path
    end
  end

  def offerable_menu_params
    params.require(:offerable_menu).permit(:offerable_id, :offerable_type)
  end
end