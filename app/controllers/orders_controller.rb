class OrdersController < ApplicationController
  before_action :set_restaurant_and_check_user

  def index
    @orders = @restaurant.orders
  end

  def show
    @order = Order.find(params[:id])
    @order_offerings = @order.order_offerings
  end

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

  def send_to_kitchen
    @order = Order.find(params[:id])
    @order.status = 'pending_kitchen'
    if @order.save
      redirect_to root_path, notice: 'Pedido enviado à cozinha'
    else
      flash.now[:notice] = 'Não foi possível finalizar o pedido'
      @order_offerings = @order.order_offerings
      render :show, status: :unprocessable_entity
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