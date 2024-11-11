class OrdersController < ApplicationController
  before_action :set_restaurant_and_check_user
  def new
    @order = Order.new
  end

  def create
    @order = @restaurant.orders.build(order_params)

    if @order.save
      redirect_to root_path, notice: 'Pedido criado com sucesso'
    else
      flash.now[:notice] = 'Pedido não criado'
      render :new, status: :unprocessable_entity
    end
  end

  private
  def set_restaurant_and_check_user
    @restaurant = Restaurant.find(params[:restaurant_id])  
  
    if !(current_user.owner? && current_user == @restaurant.owner) && !(current_user.employee? && current_user.works_at_restaurant == @restaurant)
      redirect_to root_path
    end
  end

  def order_params
    params.require(:order).permit(:customer_name, :cpf, :email, :phone_number)
  end
end