# frozen_string_literal: true

require 'optparse'
options = ARGV.getopts('l')
file_array = ARGV[0] ? ARGV : $stdin.readlines

line_total = []
word_total = []
file_size_total = []

if options['l']
  file_array.each do |file|
    fs = File.open(file)
    line_count = fs.read.chomp.count("\n") + 1
    line_total << line_count
    print line_count.to_s.rjust(8)
    print " #{file}\n"
  end
  if file_array[1]
    print line_total.sum.to_s.rjust(8)
    print " total\n"
  end

else
  file_array.each do |file|
    fs = File.open(file)
    line_count = fs.read.chomp.count("\n") + 1
    fs.rewind
    word = fs.read.chomp.split(/\s+/)
    word_count = word.count
    file_size = File.size(file)

    line_total << line_count
    word_total << word_count
    file_size_total << file_size

    print line_count.to_s.rjust(8)
    print word_count.to_s.rjust(8)
    print file_size.to_s.rjust(8)
    print " #{file}\n"
  end
  if file_array[1]
    print line_total.sum.to_s.rjust(8)
    print word_total.sum.to_s.rjust(8)
    print file_size_total.sum.to_s.rjust(8)
    print " total\n"
  end
end

