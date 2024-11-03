class RestaurantsController < ApplicationController
  before_action :redirect_user, only: [:index, :show, :edit]
  before_action :set_restaurant_and_check_user_is_owner, only: [:update]
  def index
    @restaurant = current_user.restaurant
  end

  def new
    if current_user.restaurant.present?
      redirect_to root_path
    end
    @restaurant = Restaurant.new
    build_shifts
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    if current_user == @restaurant.user
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
      
      redirect_to root_path, notice: "Restaurante cadastrado com sucesso."
    else
      flash.now[:notice] = "Restaurante não cadastrado."
      build_remaining_shifts
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    build_remaining_shifts
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_params)
      redirect_to restaurant_path(@restaurant), notice: 'Restaurante editado com sucesso'
    else
      flash.now[:alert] = 'Restaurante não editado'
      build_remaining_shifts
      render :edit, status: :unprocessable_entity
    end
  end
  

  private
  def restaurant_params
    params.require(:restaurant).permit(:registered_name, :trade_name, :cnpj, :email, :street_address, 
                                       :city, :state, :district, :zip_code, :code, :user, :phone_number, 
                                       shifts_attributes: [:id, :weekday, :opening_time, :closing_time, :_destroy])
  end

  def redirect_user
    if !current_user.restaurant.present?
      redirect_to new_restaurant_path
    end
  end

  def set_restaurant_and_check_user_is_owner
    @restaurant = Restaurant.find(params[:id])
    if current_user != @restaurant.user
      redirect_to root_path
    end
  end
  
  def build_shifts
    Shift.weekdays.each do |weekday|
      @restaurant.shifts.build(weekday: weekday.first)
    end
  end

  def build_remaining_shifts
    Shift.weekdays.each do |weekday|
      if !@restaurant.shifts.exists?(weekday: weekday)
        @restaurant.shifts.build(weekday: weekday.first)
      end
    end
  end

end
