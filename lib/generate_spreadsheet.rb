require "csv"
require "json"

def requests
  h = {}
  Enumerator.new do |y|
    Dir.glob("#{__dir__}/../input/dates/*.json").sort.reverse.each do |file|
      JSON.parse(IO.read(file)).each do |request|
        unless h[request['service_request_id']]
          y << request
          h[request['service_request_id']] = true
        end
      end
    end
  end
end

fields = {
  "service_request_id" => nil,
  "url" => ->(r) { "https://311.boston.gov/tickets/#{r['service_request_id']}" },
  "status" => nil,
  "status_notes" => nil,
  "service_name" => nil,
  "service_code" => nil,
  "description" => nil,
  "requested_datetime" => nil,
  "updated_datetime" => nil,
  "address" => nil,
  "lat" => nil,
  "long" => nil,
  "media_url" => nil,
  "token" => nil,
}

puts fields.keys.to_csv

requests.each do |request|
  values = fields.map do |k,v|
    if v
      v.call(request)
    else
      request[k]
    end
  end
  puts values.to_csv
end
