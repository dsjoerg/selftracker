require 'csv'
require 'active_support/time'

dj_zone = ActiveSupport::TimeZone.new("Eastern Time (US & Canada)")
numlines = 0
observations = []
CSV.foreach("/Users/david/Downloads/swdata (1).csv") do |row|
  if numlines > 0
    observation_time = Time.parse(row[0]+"+00:00")
    observation_time = observation_time.in_time_zone(dj_zone)
    date = observation_time.strftime('%Y%m%d')
    observations << {:date => date, :numThreads => row[2].to_i}
  end
  numlines = numlines + 1
end
obs_by_date = observations.group_by { |obs| obs[:date] }
threads_by_date = obs_by_date.merge(obs_by_date){ |date, obs_for_date| obs_for_date.map{|obs| obs[:numThreads] } }
min_threads_by_date = threads_by_date.merge(threads_by_date){ |date, threads_for_date| threads_for_date.min }
min_threads_by_date.each { |date, minThreads|
  puts "#{date} #{minThreads}"
}

