require "Date"
require 'optparse'

month_year = ARGV.getopts('m:', 'y:')
year = month_year["y"].to_i
month = month_year["m"].to_i

if year == 0
    year = Date.today.year
end

if month == 0
    month = Date.today.month
end

head = "#{month}月 #{year}"
puts head.center(20)
puts "日 月 火 水 木 金 土"

first_day = Date.new(year, month , 1);
last_day = Date.new(year, month , -1); 

count = first_day.wday
space = "   " * first_day.wday
print space

range = first_day.day..last_day.day
range.each do |day|
    print day.to_s.rjust(2)
    print " "
    count = count + 1
    if (count % 7 == 0)
        print("\n")
    end
end
puts ""

