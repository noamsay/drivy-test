require 'json'
require_relative '../level1/drivyrentals'

INPUT_FILEPATH = 'data/input.json'
OUTPUT_FILEPATH = 'data/noam_output.json'

# initiate DrivyRental class with input and output files
drivy = DrivyRentals.new(
  input_file: INPUT_FILEPATH,
  output_file: OUTPUT_FILEPATH
  )

# hydrate cars from input json
cars = drivy.cars_hydration

# hydrate rentals from input json
rentals = drivy.rentals_hydration(cars)

# create a list of rentals with price
drivy.rental_list_with_price(rentals, 'level2')

# serialize the rentals list to output json
drivy.rentals_serialization_to_json('level2')
