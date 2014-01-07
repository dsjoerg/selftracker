require 'active_support/time'
require 'net/http'
require 'json'

swdata_json = Net::HTTP.get('free-ec2.scraperwiki.com', '/eq7wjwa/5d0648f0a88f4fd/sql?q=select+*+from+swdata')
swdata = JSON.parse(swdata_json)

dj_zone = ActiveSupport::TimeZone.new("Eastern Time (US & Canada)")
observations = []
swdata.each do |row|
  observation_time = Time.parse(row["observation_time"]+"+00:00")
  observation_time = observation_time.in_time_zone(dj_zone)
  date = observation_time.strftime('%Y%m%d')
  observations << {:date => date, :numThreads => row["numThreads"]}
end
obs_by_date = observations.group_by { |obs| obs[:date] }
threads_by_date = obs_by_date.merge(obs_by_date){ |date, obs_for_date| obs_for_date.map{|obs| obs[:numThreads] } }
min_threads_by_date = threads_by_date.merge(threads_by_date){ |date, threads_for_date| threads_for_date.min }
min_threads_by_date.each { |date, minThreads|
  puts "#{date} #{minThreads}"
}

