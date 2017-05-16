require_relative 'station'
require_relative 'journey'

class Oystercard
  attr_reader :balance, :journeys

  def initialize
    @balance = 0
    @journeys = []
    @current_journey = Journey.new
  end

  BALANCE_LIMIT = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 2

  def top_up(amount)
    fail "Maximum balance of £#{BALANCE_LIMIT} exceeded" if @balance + amount > BALANCE_LIMIT
    @balance += amount
  end

  def touch_in(entry_station)
    fail "Insufficient balance to travel" if @balance < MINIMUM_BALANCE
    @current_journey.start_journey(entry_station)
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @current_journey.end_journey(exit_station)
    @journeys << @current_journey.stations
  end

  def in_journey?
    !!@current_journey.stations[:entry_station] && !@current_journey.stations[:exit_station]
  end

  private

  def deduct(fare)
    @balance -= fare
  end
end
