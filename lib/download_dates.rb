require "date"
require "json"
require "logger"
require "tempfile"

$retry_count = 5
$retry_sleep = 60
$request_sleep = 7

$logger = Logger.new($stderr, level: Logger::INFO)

# fetch from open311 api
def curl_requests(start_time, end_time)
  fmt = "%Y-%m-%dT%T"
  Tempfile.create do |tmpfile|
    system("curl", "-s", "https://311.boston.gov/open311/v2/requests.json?start_date=#{start_time.strftime fmt}Z&end_date=#{end_time.strftime fmt}Z", "-o", tmpfile.path)
    sleep $request_sleep
    IO.read(tmpfile.path)
  end
end

# catches any error and retries command n times
def retry_it(n)
  n.times do
    begin
      return yield
    rescue
      $logger.info "failure! #{$!.message} retry in #{$retry_sleep}"
      sleep $retry_sleep
    end
  end
  raise "reached max retries #{n}"
end

# fetches requests with retries on failure and saves to disk
def fetch_cache_requests(start_time, end_time)
  fmt = "%Y-%m-%dT%T"
  output_path = "#{__dir__}/../input/dates/#{start_time.strftime(fmt)}_#{end_time.strftime(fmt)}.json"
  retry_it($retry_count) do 
    unless File.exist? output_path
      $logger.info "fetch #{output_path}"
      response = curl_requests(start_time, end_time)
      JSON.parse(response)
      IO.write(output_path, response)
    end
    JSON.parse(IO.read(output_path))
  end
end

# download between times and recurses if results truncated
def get_times(start_time, end_time)
  requests = fetch_cache_requests(start_time, end_time)
  if requests.count > 40
    # ask for smaller times because we hit the requests per response limit
    mid_time = Time.at((start_time.to_i + end_time.to_i)/2)
    requests = [*requests, *get_times(start_time, mid_time)]
    requests = [*requests, *get_times(mid_time, end_time)]
  end
  requests.uniq { |r| r["service_request_id"] }
end

# download the specified date
def get_date(date)
  start_time = date.to_time
  end_time = (date+1).to_time
  get_times(start_time, end_time)
end

# 2008-01-01 should be start if we want everything but that would take forever
(Date.new(2023, 1, 1) ... (Date.today - 1)).to_a.reverse.each do |date|
  get_date(date)
end
