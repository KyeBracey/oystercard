require 'journey'

describe Journey do
  let(:journey) { described_class.new }
  let(:oystercard) { double(:oystercard) }
  let(:stations) { {entry_station: entry_station, exit_station: exit_station} }

  describe '#start_journey' do
    it 'should add entry station to hash' do
      journey.start_journey(entry_station)
      expect(journey.stations[entry_station]).to eq entry_station
    end
  end

  describe '#end_journey' do
    it 'should add exit station to hash' do
      journey.end_journey(exit_station)
      expect(journey.stations[exit_station]).to eq exit_station
    end
  end

  describe '#complete?' do
    it 'should return false if journey was started but not finished' do
      journey.start_journey(entry_station)
      expect(journey.complete?).to eq false
    end

    it 'should return false if journey was finished but not started' do
      journey.end_journey(exit_station)
      expect(journey.complete?).to eq false
    end

    it 'should return true if journey was completed' do
      journey.start_journey(entry_station)
      journey.end_journey(exit_station)
      expect(journey.complete?).to eq true
    end
  end

end
