class OfferingsController < ApplicationController
  before_action :set_offerable_and_check_user_is_owner
  before_action :offering_permitted_params, only: [:create]

  def show
    @restaurant = Restaurant.find(params[:restaurant_id])
    @offering = Offering.find(params[:id])
    @price_histories = @offering.price_histories.order('effective_at DESC')
  end
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @offering = @offerable.offerings.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @offering = @offerable.offerings.new(offering_permitted_params)
    if @offerable.save
      redirect_to [@offerable.restaurant, @offerable], notice: 'Porção cadastrada com sucesso'
    else
      flash.now[:notice] = 'Porção não cadastrada'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:restaurant_id])
    @offering = Offering.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:restaurant_id])
    @offering = Offering.find(params[:id])

    if @offering.update(offering_permitted_params)
      redirect_to [@restaurant, @offerable], notice: 'Preço alterado com sucesso'
    else
      flash.now[:notice] = 'Preço não foi alterado'
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def set_offerable_and_check_user_is_owner
    if current_user != Restaurant.find(params[:restaurant_id]).owner
      redirect_to root_path
    else
      if params[:dish_id]
        @offerable = Dish.find(params[:dish_id])
      else
        @offerable = Beverage.find(params[:beverage_id])
      end
    end
  end

  def offering_permitted_params
    params.require(:offering).permit(:description, :current_price) 
  end

end