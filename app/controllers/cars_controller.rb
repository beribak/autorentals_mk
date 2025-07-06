class CarsController < ApplicationController
  before_action :set_car, only: [ :show ]

  def index
    @cars = Car.all.order(:brand, :model)

    # Add filtering capability
    @cars = @cars.where("brand ILIKE ?", "%#{params[:brand]}%") if params[:brand].present?
    @cars = @cars.where("year >= ?", params[:year_from]) if params[:year_from].present?
    @cars = @cars.where("year <= ?", params[:year_to]) if params[:year_to].present?
    @cars = @cars.where("price_per_day <= ?", params[:max_price]) if params[:max_price].present?

    # Date-based availability filtering
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil

      if start_date && end_date && start_date <= end_date
        # Find cars that are available for the selected date range
        unavailable_car_ids = Booking.active
                                    .for_date_range(start_date, end_date)
                                    .pluck(:car_id)

        @cars = @cars.where.not(id: unavailable_car_ids)
        @date_filtered = true
        @filter_start_date = start_date
        @filter_end_date = end_date
      end
    end

    # General availability filtering (as fallback)
    unless @date_filtered
      if params[:availability].present?
        case params[:availability]
        when "available"
          @cars = @cars.where(available: true)
        when "unavailable"
          @cars = @cars.where(available: false)
        when "all"
          # Show all cars regardless of availability
        end
      else
        # Default to showing only available cars
        @cars = @cars.where(available: true)
      end
    end
  end

  def show
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end
end
