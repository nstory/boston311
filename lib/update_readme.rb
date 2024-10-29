require "csv"

README_PATH = "#{__dir__}/../README.md"

def dates
  $dates ||= CSV.foreach("#{__dir__}/../output/boston311.csv", headers: true).map do |row|
    Date.parse(row["requested_datetime"])
  end
end

# find earliest and latest date in spreadsheet
min = dates.min
max = dates.max
count = dates.count
size = `du -h #{__dir__}/../output/boston311.csv`.strip.sub(/\s.*/, "")

# update the readme
readme = IO.read(README_PATH)
readme.sub! /The spreadsheet was last updated.*/, "The spreadsheet was last updated #{Date.today} and contains #{count} requests (#{size} of data) from #{min} through #{max}."
IO.write(README_PATH, readme)
