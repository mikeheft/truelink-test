#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/commands/find_pairs'

# Check if the correct number of arguments is provided
if ARGV.length != 2
  puts 'Usage: find-pairs path_to_file balance'
  exit 1
end

file = ARGV[0]
balance = ARGV[1].to_i

# Check if the file exists
unless File.exist?(file)
  puts "Error: File '#{file}' not found."
  exit 1
end

file = File.read(file)

begin
  # Call the FindPairs command
  result = Commands::FindPairs.call(file:, balance:)

  if result == 'Not possible'
    puts result
  else
    output = result.map { |pair| "#{pair.name} #{pair.price}" }.join(', ')
    puts output
  end
rescue StandardError => e
  # Handle any other errors that may occur
  puts "An error occurred: #{e.message}"
  exit 1
end
