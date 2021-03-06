require 'json'
require_relative 'option'
require_relative '../level1/drivyrentals'


INPUT_FILEPATH = 'data/input.json'
OUTPUT_FILEPATH = 'data/noam_output.json'

drivy = DrivyRentals.new(
  input_file: INPUT_FILEPATH,
  output_file: OUTPUT_FILEPATH
  )

# hydrate cars from input.json
cars = drivy.cars_hydration

# hydrate rentals from input.json
rentals = drivy.rentals_hydration(cars)

# hydrate options from input.json
options = drivy.options_hydration(rentals)

# add options to rentals
drivy.add_options_to_rentals(options, rentals)

# create a list of rentals with price
drivy.rental_list_with_options(rentals)

# serialize the rentals list to output json
drivy.rentals_serialization_to_json('level5')
