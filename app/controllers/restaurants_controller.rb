class RestaurantsController < ApplicationController
  before_action :redirect_user_from_index, only: [:index]
  before_action :redirect_user_from_show, only: [:show]
  before_action :set_restaurant_and_check_user_is_owner, only: [:edit, :update, :manage_employees, :search]
  def index
    @restaurant = current_user.owned_restaurant
  end

  def new
    if current_user.owned_restaurant.present? || current_user.employee?
      redirect_to root_path
    end
    @restaurant = Restaurant.new
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @menus = @restaurant.menus
    if current_user == @restaurant.owner
      @dishes = @restaurant.dishes
      @beverages = @restaurant.beverages
    else
      @dishes = @restaurant.dishes.active
      @beverages = @restaurant.beverages.active
    end
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user_id = current_user.id
 
    if @restaurant.save
      
      redirect_to restaurant_shifts_path(@restaurant), notice: "Restaurante cadastrado com sucesso."
    else
      flash.now[:notice] = "Restaurante não cadastrado."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_params)
      redirect_to restaurant_path(@restaurant), notice: 'Restaurante editado com sucesso'
    else
      flash.now[:alert] = 'Restaurante não editado'
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @query = params[:query]
    @dishes = @restaurant.dishes.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
    @beverages = @restaurant.beverages.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
  end

  def manage_employees
    @new_employees = @restaurant.new_employees
  end

  def test
    @restaurant = Restaurant.find(params[:id])
  end
  

  private
  def restaurant_params
    params.require(:restaurant).permit(:registered_name, :trade_name, :cnpj, :email, :street_address, 
                                       :city, :state, :district, :zip_code, :code, :user, :phone_number, 
                                       shifts_attributes: [:id, :weekday, :opening_time, :closing_time, :_destroy])
  end

  def redirect_user_from_index
    if current_user.owner?
      if !current_user.owned_restaurant.present?
        redirect_to new_restaurant_path
      end
    else
      redirect_to restaurant_path(current_user.works_at_restaurant)
    end
  end

  def redirect_user_from_show
    if current_user.owner?
      if !current_user.owned_restaurant.present?
        redirect_to new_restaurant_path
      end
    else
      @restaurant = Restaurant.find(params[:id])
      if current_user.works_at_restaurant != @restaurant
        redirect_to restaurant_path(current_user.works_at_restaurant)
      end
    end
  end

  def set_restaurant_and_check_user_is_owner
    @restaurant = Restaurant.find(params[:id])
    if current_user != @restaurant.owner
      redirect_to root_path
    end
  end
end
