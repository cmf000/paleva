class Api::V1::OrdersController < ActionController::API
  before_action :set_restaurant, only: [:index]
  before_action :set_order_and_check_order_belongs_to_restaurant, only: [:show, :preparing, :ready]

  def index
    status = params[:status]
    if status.present? && status != 'draft'
      orders = @restaurant.orders.where(status: status)
    else
      orders = @restaurant.orders.where.not(status: :draft)
    end
    if orders.empty?
      return head :no_content
    else
      return render status: 200, json: orders.as_json(only: [:code, :status])
    end
  end

  def show
    if !@order.draft?
      render status: 200, json: json_response(@order)
    else
      render status: 403, json: { errors: "Pedido não finalizado" }
    end
  end

  def preparing
    @order.status = "preparing"
    if @order.save
      render status: 200, json: json_response(@order)
    else
      render status: 400, json: {errors: @order.errors}
    end
  end

  def ready
    @order.status = "ready"
    if @order.save 
      render status: 200, json: json_response(@order)
    else
      render status: 400, json: {errors: @order.errors}
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

  def set_order_and_check_order_belongs_to_restaurant
    set_restaurant
    begin
      @order = @restaurant.orders.find_by!(code: params[:code])
    rescue
      render status: 404, json: "{}"
    end
  end

  def json_response order
    order.as_json(include: { order_offerings: { 
                             include: { offering: { 
                                        include: { offerable: { 
                                                   only: :name } }, 
                                        only: [:description]} }, 
                             only: [:quantity, :comment] } }, 
                    only: [:status, :code] )
  end
end