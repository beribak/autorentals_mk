class Admin::CarsController < Admin::ApplicationController
  before_action :set_car, only: [ :show, :edit, :update, :destroy, :toggle_availability ]

  def index
    @cars = Car.all.order(:brand, :model)
    @total_cars = @cars.count
    @available_cars = @cars.where(available: true).count
    @total_revenue = @cars.sum(:price_per_day)
  end

  def show
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)

    if @car.save
      redirect_to admin_cars_path, notice: "Car was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @car.update(car_params)
      redirect_to admin_cars_path, notice: "Car was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @car.destroy
    redirect_to admin_cars_path, notice: "Car was successfully deleted."
  end

  # Toggle availability action
  def toggle_availability
    @car = Car.find(params[:id])
    @car.update(available: !@car.available?)

    status = @car.available? ? "available" : "unavailable"
    redirect_to admin_cars_path, notice: "Car has been marked as #{status}."
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:brand, :model, :year, :price_per_day, :description, :image_url, :available)
  end
end
