# typed: true
# frozen_string_literal: true

require 'spec_helper'

describe Commands::DelimiterSniffer do
  describe '.call' do
    subject(:find_delimiter) { described_class.call(File.read(path)) }

    let(:path) { './spec/fixtures/vehicle_info_with_commas.txt' }

    context 'when , delimiter' do
      it 'returns separator' do
        expect(find_delimiter).to eq(',')
      end
    end

    context 'when ; delimiter' do
      let(:path) { './spec/fixtures/vehicle_info_with_semicolons.txt' }

      it 'returns separator' do
        expect(find_delimiter).to eq(';')
      end
    end

    context 'when | delimiter' do
      let(:path) { './spec/fixtures/vehicle_info_with_pipes.txt' }

      it 'returns separator' do
        expect(find_delimiter).to eq('|')
      end
    end

    context 'when empty file' do
      it 'raises error' do
        expect_any_instance_of(described_class).to receive(:split_file).and_return([])
        expect { find_delimiter }.to raise_error(described_class::EmptyFile)
      end
    end

    context 'when no column separator is found' do
      it 'raises error' do
        expect_any_instance_of(described_class).to receive(:split_file).and_return([''])
        expect { find_delimiter }.to raise_error(described_class::NoColumnSeparatorFound)
      end
    end

    context 'when possible ultiple delimiters' do
      let(:path) { './spec/fixtures/vehicle_info_with_possible_mixed_delimiters.txt' }

      it 'is able to determine correct delimiter' do
        expect(find_delimiter).to eq('|')
      end
    end
  end
end
