class Journey
  attr_reader :stations

  def initialize
    @stations = {entry_station: nil, exit_station: nil}
  end

  def start_journey(entry_station)
    @stations[:entry_station] = entry_station
  end

  def end_journey(exit_station)
    @stations[:exit_station] = exit_station
  end

  def complete?
    !!@stations[:entry_station] && !!@stations[:exit_station]
  end

end
