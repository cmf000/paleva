class ShiftsController < ApplicationController
  before_action :set_restaurant_and_check_user

  def index
    @restaurant = Restaurant.find(params[:restaurant_id])
    @shift = Shift.new
  end

  def create
    @shift = @restaurant.shifts.build(shift_params)
    if @shift.save
      redirect_to restaurant_shifts_path(@restaurant), notice: 'Turno criado com sucesso'
    else
      flash.now[:notice] = "Turno não criado"
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @shift = Shift.find(params[:id])
    if @shift.destroy
      redirect_to restaurant_shifts_path(@restaurant), notice: 'Turno removido com sucesso'
    else
      flash.now[:notice] = "Turno não removido"
      render :index, status: :unprocessable_entity
    end
  end

  private
  def set_restaurant_and_check_user
    @restaurant = Restaurant.find(params[:restaurant_id])
    if current_user != @restaurant.owner
      redirect_to root_path
    end
  end

  def shift_params
    params.require(:shift).permit(:weekday, :opening_time, :closing_time)
  end
end