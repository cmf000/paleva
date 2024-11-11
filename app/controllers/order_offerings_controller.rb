class OrderOfferingsController < ApplicationController
  before_action :set_restaurant_and_offering_and_check_user
  def new
    @order_offering = OrderOffering.new
    @offerable = @offering.offerable
    @orders = @restaurant.orders.where(status: :draft)
    if @orders.empty?
      redirect_to new_restaurant_order_path(@restaurant)
    end
  end

  def create
    @order_offering = @offering.order_offerings.build(order_offering_params)

    if @order_offering.save
      redirect_to root_path, notice: "Adicionado ao pedido com sucesso"
    else
      flash.now[:notice] = "Item não foi adicionado"
      @offerable = @offering.offerable
      @orders = @restaurant.orders.where(status: :draft)
      render :new, status: :unprocessable_entity
    end
  end

  private
  def set_restaurant_and_offering_and_check_user
    @restaurant = Restaurant.find(params[:restaurant_id])
    @offering = Offering.find(params[:offering_id])
    if !(current_user.owner? && current_user.owned_restaurant == @restaurant) && !(current_user.employee? && current_user.works_at_restaurant == @restaurant)
      redirect_to root_path
    end
  end

  def order_offering_params
    params.require(:order_offering).permit(:quantity, :comment, :order_id)
  end
end