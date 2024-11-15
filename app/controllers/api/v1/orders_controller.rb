class Api::V1::OrdersController < ActionController::API
  before_action :set_restaurant
  before_action :set_order, only: [:show]

  def index
    status = params[:status]
    if status.present?
      orders = @restaurant.orders.where(status: status).where.not(status: :draft)
    else
      orders = @restaurant.orders.where.not(status: :draft)
    end
    if orders.empty?
      render status: 204
    else
      render status: 200, json: orders.as_json(except: [:created_at, :updated_at])
    end
  end

  def show
    if !@order.draft?
      render status: 200, json: @order.as_json(include: { order_offerings: { 
                                                          include: { offering: { 
                                                                     include: { offerable: { 
                                                                                only: :name } }, 
                                                                     only: [:description]} }, 
                                                           only: [:quantity, :comment] } }, 
                                                only: [:customer_name, :status, :code] )
    else
      render status: 404, json: "{}"
    end
  end

  private
  def set_restaurant
    begin
      @restaurant = Restaurant.find_by!(code: params[:restaurant_code])
    rescue
      render status: 404, json: "{}"
    end
  end

  def set_order 
    begin
      @order = Order.find_by!(code: params[:code])
    rescue
      render status: 404, json: "{}"
    end
  end
end