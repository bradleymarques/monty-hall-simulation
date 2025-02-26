# frozen_string_literal: true

DOOR_COUNT = 3
SIMULATION_COUNT_EACH_CASE = 10_000

def make_choice(door_count)
  rand(door_count) + 1
end

def find_revealed_door(car_door, initial_choice)
  (1..DOOR_COUNT).reject { |door| door == car_door || door == initial_choice }.sample
end

def simulate(simulation_number:, will_switch:)
  car_door = make_choice(DOOR_COUNT)
  initial_choice = make_choice(DOOR_COUNT)
  revealed_door = find_revealed_door(car_door, initial_choice)
  final_choice = will_switch ?
    (1..DOOR_COUNT).reject { |door| door == initial_choice || door == revealed_door }.sample :
    initial_choice

  {
    simulation_number: simulation_number,
    will_switch: will_switch,
    initial_choice: initial_choice,
    revealed_door: revealed_door,
    final_choice: final_choice,
    won: final_choice == car_door
  }
end

def run_simulations
  simulation_results = []
  (1..SIMULATION_COUNT_EACH_CASE).each do |i|
    simulation_result = simulate(simulation_number: i, will_switch: true)

    simulation_results << simulation_result
  end

  (SIMULATION_COUNT_EACH_CASE + 1..SIMULATION_COUNT_EACH_CASE * 2).each do |i|
    simulation_result = simulate(simulation_number: i, will_switch: false)

    simulation_results << simulation_result
  end

  simulation_results
end

def calculate_win_percentage(results)
  wins = results.count { |result| result[:won] }
  (wins / results.count.to_f * 100)
end

def summarize_results(simulation_results)
  puts 'Simulation results:'
  puts "Total simulations: #{simulation_results.count}"

  switching_results = simulation_results.select { |result| result[:will_switch] }
  non_switching_results = simulation_results.reject { |result| result[:will_switch] }

  puts "Switching - percentage of wins: #{calculate_win_percentage(switching_results)}%"
  puts "Non-switching - percentage of wins: #{calculate_win_percentage(non_switching_results)}%"
end

simulation_results = run_simulations

summarize_results(simulation_results)
