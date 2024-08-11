require 'spec_helper'
require 'open3'

RSpec.describe 'find-pairs script' do
  let(:script_path) { './bin/find-pairs' }
  let(:fixture_file) { './spec/fixtures/prices_with_commas.txt' }

  it 'returns the correct result for valid arguments' do
    command = "#{script_path} #{fixture_file} 2300"
    stdout, _stderr, status = Open3.capture3(command)

    expect(status.exitstatus).to eq(0)
    expect(stdout).to eq("Paperback Book 700, Headphones 1400\n")
  end

  it 'returns "Not possible" when no pairs are under the balance' do
    command = "#{script_path} #{fixture_file} 500"
    stdout, _stderr, status = Open3.capture3(command)

    expect(status.exitstatus).to eq(0)
    expect(stdout).to include('Not possible')
  end

  it 'handles file not found error' do
    command = "#{script_path} non_existent_file.txt 1000"
    stdout, _stderr, status = Open3.capture3(command)

    expect(status.exitstatus).to eq(1)
    expect(stdout).to include("Error: File 'non_existent_file.txt' not found.")
  end

  it 'handles invalid arguments' do
    command = "#{script_path} #{fixture_file}"
    stdout, _stderr, status = Open3.capture3(command)

    expect(status.exitstatus).to eq(1)
    expect(stdout).to include('Usage: find-pairs path_to_file balance')
  end
end
