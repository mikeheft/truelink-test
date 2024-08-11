require 'spec_helper'
require './lib/commands/delimiter_sniffer'
require './lib/commands/find_pairs'

RSpec.describe Commands::FindPairs do
  describe '.call' do
    let(:file_content) do
      "Candy Bar,500\nPaperback Book,700\nDetergen,1000\nHeadphones,1400\nEarmuffs,2000\nBluetooth Stereo,6000"
    end

    before do
      allow(Commands::DelimiterSniffer).to receive(:call).and_return(',')
    end

    context 'when there are valid pairs within the balance' do
      it 'returns the pair with the highest total price within the balance of 2000' do
        file = file_content
        balance = 2000

        result = described_class.call(file:, balance:)

        expected = [
          OpenStruct.new(name: 'Candy Bar', price: 500),
          OpenStruct.new(name: 'Headphones', price: 1400)
        ]

        expect(result).to eq(expected)
      end

      it 'returns the pair with the highest total price for a balance of 2300' do
        file = file_content
        balance = 2300

        result = described_class.call(file:, balance:)

        expected = [
          OpenStruct.new(name: 'Paperback Book', price: 700),
          OpenStruct.new(name: 'Headphones', price: 1400)
        ]

        expect(result).to eq(expected)
      end

      it 'returns the pair with the highest total price for a balance of 2500' do
        file = file_content
        balance = 2500

        result = described_class.call(file:, balance:)

        expected = [
          OpenStruct.new(name: 'Candy Bar', price: 500),
          OpenStruct.new(name: 'Earmuffs', price: 2000)
        ]

        expect(result).to eq(expected)
      end
    end

    context 'when there are no valid pairs within the balance' do
      it 'returns "Not possible" for balance of 500' do
        file = file_content
        balance = 500

        result = described_class.call(file:, balance:)

        expect(result).to eq('Not possible')
      end

      it 'returns "Not possible" for a balance of 1100' do
        file = file_content
        balance = 1100

        result = described_class.call(file:, balance:)

        expect(result).to eq('Not possible')
      end
    end

    context 'when file has only one item' do
      it 'returns "Not possible"' do
        file = 'Candy Bar,500'
        balance = 2000

        result = described_class.call(file:, balance:)

        expect(result).to eq('Not possible')
      end
    end
  end
end
