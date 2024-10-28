class HomeController < ApplicationController
  before_action :redirect_user
  def index; end

  private
  def redirect_user
    if current_user.restaurant.present?
      redirect_to restaurants_path
    else
      redirect_to new_restaurant_path
    end
  end  
end