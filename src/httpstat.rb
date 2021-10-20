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

def fmta(s)
  cyan((s + 'ms').rjust(7))
end

def fmtb(s)
  cyan((s + 'ms').ljust(7))
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

https_template = %Q(
  DNS Lookup   TCP Connection   TLS Handshake   Server Processing   Content Transfer
[   {a0000}  |     {a0001}    |    {a0002}    |      {a0003}      |      {a0004}     ]
             |                |               |                   |                  |
    namelookup:{b0000}        |               |                   |                  |
                        connect:{b0001}       |                   |                  |
                                    pretransfer:{b0002}           |                  |
                                                      starttransfer:{b0003}          |
                                                                                 total:{b0004}
)


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

d.each do |k, v|
  if k.start_with?("time_")
    if v == v.to_i
      d[k] = (v/1000.0).to_i
    else
      d[k] = (v * 1000).to_i
    end
  end
end

d.merge!({
  'range_connection' => d['time_connect'] - d['time_namelookup'],
  'range_ssl' => d['time_pretransfer'] - d['time_connect'],
  'range_server' => d['time_starttransfer'] - d['time_pretransfer'],
  'range_transfer' => d['time_total'] - d['time_starttransfer']
})

https_template.sub!("{a0000}", fmta(d['time_namelookup'].to_s))
https_template.sub!("{a0001}", fmta(d['range_connection'].to_s))
https_template.sub!("{a0002}", fmta(d['range_ssl'].to_s))
https_template.sub!("{a0003}", fmta(d['range_server'].to_s))
https_template.sub!("{a0004}", fmta(d['range_transfer'].to_s))

https_template.sub!("{b0000}", fmtb(d['time_namelookup'].to_s))
https_template.sub!("{b0001}", fmtb(d['time_connect'].to_s))
https_template.sub!("{b0002}", fmtb(d['time_pretransfer'].to_s))
https_template.sub!("{b0003}", fmtb(d['time_starttransfer'].to_s))
https_template.sub!("{b0004}", fmtb(d['time_total'].to_s))
puts https_template

if ENV['HTTPSTAT_SHOW_SPEED'].to_s.downcase == 'true'
  puts('speed_download: %.1f KiB/s, speed_upload: %.1f KiB/s' %
    [d['speed_download'] / 1024, d['speed_upload'] / 1024])
end
