require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) {double :station}
  let(:exit_station) {double :station}

    it 'has a an intial balance' do
      expect(oystercard.balance).to eq(0)
    end

    it 'has an empty list of journeys by default' do
      expect(oystercard.journeys).to be_empty
    end

    describe '#top_up' do
      it 'can top up the balance' do
        expect{ oystercard.top_up 10 }.to change{ oystercard.balance }.by 10
      end

      it 'raises and error if top_up exceeds the maximum monetary balance' do
        oystercard.top_up(Oystercard::BALANCE_LIMIT)
        expect{ oystercard.top_up 1 }.to raise_error "Maximum balance of £#{Oystercard::BALANCE_LIMIT} exceeded"
      end
    end

    describe '#touch_in' do
      context 'topped up before touching in' do
        before(:each) do
          oystercard.top_up(Oystercard::MINIMUM_BALANCE)
          oystercard.touch_in(:entry_station)
        end

        it 'allows a user to touch in' do
          expect(oystercard).to be_in_journey
        end

        it 'remembers the entry station' do
          expect(oystercard.entry_station).to eq :entry_station
        end
      end

      context 'insufficient funds on card' do
        let(:oystercard) { described_class.new }

        it 'will not touch in if balance is below minimum' do
          expect{ oystercard.touch_in(:entry_station) }.to raise_error "Insufficient balance to travel"
        end
      end
    end

    describe '#touch_out' do
      let(:journey) { {entry_station: :entry_station, exit_station: :exit_station} }
      before(:each) do
        oystercard.top_up(Oystercard::BALANCE_LIMIT)
        oystercard.touch_in(:entry_station)
      end

      it 'allows a user to touch out' do
        oystercard.touch_out(:exit_station)
        expect(oystercard).not_to be_in_journey
      end

      it 'deducts the fare from the balance of the oystercard' do
        expect{ oystercard.touch_out(:station) }.to change{ oystercard.balance }.by(-Oystercard::MINIMUM_FARE)
      end

      it 'touching in and out should create one journey' do
        oystercard.touch_out(:exit_station)
        expect(oystercard.journeys).to include journey
      end
    end
end
