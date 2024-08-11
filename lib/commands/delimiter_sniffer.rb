# frozen_string_literal: true

module Commands
  # Mimics the built in library in Python's CSV module that will determine the
  # delimiter for a 'csv' file. This ensures that we are not having to have multiple
  # implementations for each different possible delimiter.
  # Should more become 'more common', we can update the COMMON_DELIMITERS constant
  # to reflect that.
  class DelimiterSniffer
    NoColumnSeparatorFound = Class.new(StandardError)
    EmptyFile = Class.new(StandardError)

    COMMON_DELIMITERS = [
      '","',
      '"|"',
      '";"'
    ].freeze
    private_constant :COMMON_DELIMITERS

    def self.call(file)
      # In order to maintain a single caller for this file, we want to use private methods.
      # However, Rails does not play well with this pattern w/o the need for calling #send.
      # This is safe as we are not using metaprogramming for this call so no further validation is required
      # that the method exists.
      new(file:).send(:find_delimiter)
    end

    attr_reader :file
    private :file

    private def find_delimiter
      raise EmptyFile unless first

      raise NoColumnSeparatorFound unless valid?

      delimiters[0]&.[](0)&.[](1)
    end

    private def initialize(file:)
      @file = file
    end

    private def valid?
      !delimiters.collect(&:last).reduce(:+).zero?
    end

    # delimiters #=> [["\"|\"", 54], ["\",\"", 0], ["\";\"", 0]]
    # delimiters[0] #=> ["\";\"", 54]
    # delimiters[0][0] #=> "\",\""
    # delimiters[0][0][1] #=> ";"
    private def delimiters
      @delimiters ||= COMMON_DELIMITERS.inject({}, &count).sort(&most_found)
    end

    private def most_found
      ->(a, b) { b[1] <=> a[1] }
    end

    private def count
      ->(hash, delimiter) {
        hash[delimiter] = first&.count(delimiter)
        hash
      }
    end

    private def first
      @first ||= split_file.first
    end

    private def split_file
      @split_file ||= file.split("\n")
    end
  end
end
