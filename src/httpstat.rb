# References:
# https://github.com/reorx/httpstat

require 'shellwords'
require 'json'
require 'tempfile'

COLORS = {
  :cyan => 36,
  :green => 32
}

GRAYSCALE = 232.upto(255).collect do |i|
  "38;5;#{i}"
end

def cyan(text)
  "\e[#{COLORS[:cyan]}m#{text}\e[0m"
end

def green(text)
  "\e[#{COLORS[:green]}m#{text}\e[0m"
end

def grayscale(index, text)
  "\e[#{GRAYSCALE[index]}m#{text}\e[0m"
end

USAGE = %Q(
Usage: httpstat URL

Arguments:
  URL     url to request, could be with or without `http(s)://` prefix
)[1..-1]

if ARGV.length != 1
  puts USAGE
  exit
end

curl_format = %Q({
"time_namelookup": %{time_namelookup},
"time_connect": %{time_connect},
"time_appconnect": %{time_appconnect},
"time_pretransfer": %{time_pretransfer},
"time_redirect": %{time_redirect},
"time_starttransfer": %{time_starttransfer},
"time_total": %{time_total},
"speed_download": %{speed_download},
"speed_upload": %{speed_upload},
"remote_ip": "%{remote_ip}",
"remote_port": "%{remote_port}",
"local_ip": "%{local_ip}",
"local_port": "%{local_port}"
})

hf = Tempfile.new
hf.close

o = `curl -w #{Shellwords.escape(curl_format)} -D #{Shellwords.escape(hf.to_path)} #{Shellwords.escape(ARGV.first)} -o /dev/null --stderr /dev/null`
d = JSON.parse(o)

puts "Connected to #{cyan(d['remote_ip'])}:#{cyan(d['remote_port'])} from #{d['local_ip']}:#{d['local_port']}"

headers = File.read(hf.to_path)

puts ""
headers.split("\r\n").each_with_index do |header, index|
  if index == 0
    p1, p2 = header.split('/')
    puts(green(p1) + grayscale(14, '/') + cyan(p2.to_s.strip))
  else
    key, value = header.split(":")
    puts "#{grayscale(16, key+":")} #{cyan(value.to_s.strip)}"  
  end
end
