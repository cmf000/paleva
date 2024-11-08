class NewEmployeesController < ApplicationController
  before_action :set_restaurant_and_check_user_is_owner
  def new 
    @new_employee = NewEmployee.new
  end

  def create
    @new_employee = @restaurant.new_employees.build(new_employee_params)
    if @new_employee.save
      redirect_to manage_employees_restaurant_path(@restaurant.id), notice: 'Pré-cadastro realizado com sucesso'
    else
      flash.now[:notice] = "Pré-cadastro não realizado"
      render :new, status: :unprocessable_entity, location: new_restaurant_new_employee_path(@restaurant)
    end
  end

  private
  def new_employee_params
    params.require(:new_employee).permit(:cpf, :email)
  end

  def set_restaurant_and_check_user_is_owner
    @restaurant = Restaurant.find(params[:restaurant_id])
    if current_user != @restaurant.owner
      redirect_to root_path
    end
  end
end