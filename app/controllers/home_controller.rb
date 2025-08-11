class HomeController < ApplicationController
  def homepage
    # This is the new homepage with filter form
    @featured_cars = Car.where(available: true).limit(3)
  end

  def index
    @featured_cars = Car.where(available: true).limit(3)
  end

  def contact
  end

  def ohrid
    # Article about Ohrid
  end

  def mavrovo
    # Article about Mavrovo
  end

  def matka
    # Article about Matka
  end
end
