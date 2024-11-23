# frozen_string_literal: true

require 'csv'

zips_grid = CSV.read('slcsp/zips.csv')

zip_to_areas = {}

zips_grid.each_with_index do |row, index|
  next if index.zero?

  if zip_to_areas[row[0]]
    zip_to_areas[row[0]] << ("#{row[1]}-#{row[4]}")
  else
    zip_to_areas[row[0]] = ["#{row[1]}-#{row[4]}"]
  end
end

# zipcodes do not exist in plans.csv and multiple zipcodes can have be in the same rate area
# therefore, creating a valid_areas hash for lookups will improve performance
valid_areas = {}
valid_zips = {}

# filter out invalid zipcodes that are associated with more than one rate area
zip_to_areas.each do |zip, _areas|
  next unless zip_to_areas[zip].uniq.size == 1

  valid_zips[zip] = [zip_to_areas[zip].first]
  valid_areas[zip_to_areas[zip].first] ||= []
  valid_areas[zip_to_areas[zip].first] << zip
end

# Create a list of silver plan rates for valid areas
silver_rates = {}
plans_grid = CSV.read('slcsp/plans.csv')

plans_grid.each_with_index do |row, index|
  next if index.zero?

  area_rate = "#{row[1]}-#{row[4]}"
  if valid_areas[area_rate] && row[2] == 'Silver'
    silver_rates[area_rate] ||= []
    silver_rates[area_rate] << row[3]
  end
end

# get valid slcsps
slcsps = {}
silver_rates.each do |area, rates|
  next if rates.uniq.size < 2

  slcsps[area] = silver_rates[area].uniq.sort![1]
end

# Read slcsp.csv row by row
# Use the zipcode in each row to lookup rate area in valid_zips
# Use the rate area to lookup the slcsps in slcsps hash
# Update row in slcsp.csv
slcsp_grid = CSV.read('slcsp/slcsp.csv')

slcsp_grid.each_with_index do |row, index|
  next if index.zero?
  next unless valid_zips[row[0]]

  row[1] = slcsps[valid_zips[row[0]].first]
end

CSV.open('slcsp/slcsp.csv', 'wb') { |csv| slcsp_grid.each { |row| csv << row } }

slcsp_grid.each_with_index do |row, index|
  print row[0]
  print ','
  print row[1]
  puts
end
