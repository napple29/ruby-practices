require "Date"
require 'optparse'

month_year = ARGV.getopts('m:', 'y:')
year = month_year["y"].to_i
month = month_year["m"].to_i

year = Date.today.year if year == 0
month = Date.today.month if month == 0

head = "#{month}月 #{year}"
puts head.center(20)
puts "日 月 火 水 木 金 土"

first_day = Date.new(year, month , 1);
last_day = Date.new(year, month , -1); 

space = "   " * first_day.wday
print space

range = first_day..last_day
range.each do |day|
  print day.day.to_s.rjust(2)
  print " "
  if day.saturday?
    print "\n"
  end
end
puts ""

