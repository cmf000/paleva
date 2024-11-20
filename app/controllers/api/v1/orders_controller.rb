class Api::V1::OrdersController < ActionController::API
  before_action :set_restaurant, only: [:index]
  before_action :set_order_and_check_order_belongs_to_restaurant, only: [:show, :preparing, :ready, :cancelled]

  def index
    status = params[:status]
    if status.present? && status != 'draft' && status != 'delivered'
      orders = @restaurant.orders.where(status: status)
    else
      orders = @restaurant.orders.where.not(status: :draft)
    end
    if orders.empty?
      return head :no_content
    else
      return render status: 200, json: orders.as_json(only: [:code, :status, :placed_at])
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

  def cancelled
    @order.status = "cancelled"
    order_params = params.require(:order).permit(:cancellation_note)
    if @order.update(order_params)
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
                             only: [:quantity, :comment], methods: [:item_name, :offering_description] } }, 
                    only: [:status, :code, :placed_at]).deep_transform_keys! { |key| key == 'order_offerings' ? 'items' : key }
  end
end