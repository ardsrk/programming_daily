# export HACKATTIC_TOKEN=<access_token>
# ruby help_me_unpack.rb

require 'net/https'
require 'base64'
require 'json'

unless ENV['HACKATTIC_TOKEN']
  puts "Please set 'HACKATTIC_TOKEN' environment variable"
  exit
end

url = "https://hackattic.com/challenges/help_me_unpack/problem?access_token=#{ENV['HACKATTIC_TOKEN']}"

puts "Requesting #{url} ..."
response = Net::HTTP.get_response(URI(url))

puts "Received Response: #{response.body}"

bytes = JSON.parse(response.body)['bytes']
r = Base64.decode64(bytes)

# unpack as array of 8-bit unsigned chars and re-pack without zero bytes
r = r.unpack('C*')
r.reject! { |n| n==0 }
r = r.pack('C*')

int = r[0..3].unpack('l')
uint = r[4..7].unpack('L')
short = r[8..9].unpack('s')
float = r[10..13].unpack('f')
double = r[14..21].unpack('d')
big_endian_double = r[22..29].unpack('G')

solution = {'int' => int.pop,
            'uint' => uint.pop,
            'short' => short.pop,
            'float' => float.pop,
            'double' => double.pop,
            'big_endian_double' => big_endian_double.pop}

puts "Posting solution JSON: #{solution.to_json}"

puts %x[curl -X POST "https://hackattic.com/challenges/help_me_unpack/solve?access_token=#{ENV['HACKATTIC_TOKEN']}" --data '#{solution.to_json}' --header 'Content-Type: application/json']
