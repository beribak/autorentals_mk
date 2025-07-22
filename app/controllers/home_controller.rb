class HomeController < ApplicationController
  def index
    @featured_cars = Car.where(available: true).limit(3)
  end

  def contact
  end
end
