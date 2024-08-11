# frozen_string_literal: true

require 'ostruct'
require_relative './delimiter_sniffer'

module Commands
  class FindPairs
    def self.call(file:, balance:)
      new(file, balance).send(:best_pair)
    end

    def initialize(file, balance)
      @file = file
      @balance = balance
    end
    private_class_method :new

    private def find_pairs
      @find_pairs ||= map_to_objects.combination(2).to_a
    end

    private def best_pair
      @best_pair ||= begin
        best = find_pairs.max_by do |pair|
          total = pair[0].price + pair[1].price
          total <= @balance ? total : 0
        end
        return 'Not possible' unless best

        best
      end
    end

    private def map_to_objects
      @map_to_objects ||= begin
        rows = @file.split("\n")
        rows.map(&method(:split_row))
      end
    end

    private def split_row(row)
      split_row = row.split(delimiter)
      OpenStruct.new(name: split_row[0], price: split_row[1].to_i)
    end

    private def delimiter
      @delimiter ||= DelimiterSniffer.call(@file)
    end
  end
end
