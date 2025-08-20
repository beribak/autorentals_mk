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

  def partners
    @partners = [
      {
        name: "SharOutdoors",
        url: "https://sharoutdoors.com/",
        logo: "http://sharoutdoors.com/wp-content/uploads/2022/11/1-2-scaled.jpg",
        description: "Adventures in Macedonia and in the Balkans. If your next holiday includes discovering new mountains, skiing, ski-touring, snowboarding, split-boarding, mountain biking, hiking, rock climbing on untouched and unique places, experience naturalness of the region and great hospitality, one of our adventures in Macedonia for sure needs to be in your next destination. Fulfilled by mountains, rivers and lakes it’s the perfect destination for people hungry for new adventures in the outdoors. Your holiday in the Balkans would never be the same again after experiencing the hidden treasures of Macedonia."
      }
    ]
  end
end
