# export HACKATTIC_TOKEN=<access_token>
# ruby backup_restore.rb

require 'net/https'
require 'base64'
require 'json'

unless ENV['HACKATTIC_TOKEN']
  puts "Please set 'HACKATTIC_TOKEN' environment variable"
  exit
end

url = "https://hackattic.com/challenges/backup_restore/problem?access_token=#{ENV['HACKATTIC_TOKEN']}"

puts "Requesting #{url} ..."
response = Net::HTTP.get_response(URI(url))

puts "Received Response: #{response.body[0..80]} ..."

dump = JSON.parse(response.body)['dump']
File.write('data.base64', dump)

%x[base64 -d data.base64 > data.gzip]
%x[zcat data.gzip > data.sql]

# Create Role and Database named hackattic.
%x[psql -U hackattic -d hackattic -f data.sql]

recs = %x[psql -U hackattic -d hackattic -c "select ssn from criminal_records where status='alive'"]
ssns = recs.split("\n").select {|record| record.start_with?(/ \d/)}.collect(&:strip)

solution = {alive_ssns: ssns}

puts "Posting solution JSON: #{solution.to_json}"

puts %x[curl -X POST "https://hackattic.com/challenges/backup_restore/solve?access_token=#{ENV['HACKATTIC_TOKEN']}" --data '#{solution.to_json}' --header 'Content-Type: application/json']
