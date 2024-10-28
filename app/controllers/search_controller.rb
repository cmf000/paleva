class SearchController < ApplicationController
  def index
    @restaurant = Restaurant.find(params[:restaurant_id])
    @query = params[:query]
    @dishes = @restaurant.dishes.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
    @beverages = @restaurant.beverages.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
  end
end