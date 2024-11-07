class HomeController < ApplicationController
  before_action :redirect_user
  def index; end

  private
  def redirect_user
    if current_user.owner?
      if current_user.owned_restaurant.present?
        redirect_to restaurants_path
      else
        redirect_to new_restaurant_path
      end
    else
      redirect_to restaurant_path(current_user.works_at_restaurant)
    end
  end  
end