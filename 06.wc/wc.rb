# frozen_string_literal: true

require 'optparse'
options = ARGV.getopts('l')

def main(options)
  files = ARGV[0] ? ARGV : $stdin.read

  if ARGV[0] && options['l']
    output_argv_l_option(files)
  elsif ARGV[0]
    output_nomal_function(files)
  elsif ARGV[1].nil? && options['l']
    output_stdin_l_option(files)
  else
    output_stdin(files)
  end
end

def output_argv_l_option(files)
  line_total = []
  files.each do |file|
    fs = File.open(file)
    line_count = fs.read.chomp.count("\n") + 1
    line_total << line_count
    print line_count.to_s.rjust(8)
    print " #{file}\n"
  end
  return unless files[1]

  print line_total.sum.to_s.rjust(8)
  print " total\n"
end

def output_nomal_function(files)
  line_total = []
  word_total = []
  file_size_total = []
  files.each do |file|
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
  return unless files[1]

  print line_total.sum.to_s.rjust(8)
  print word_total.sum.to_s.rjust(8)
  print file_size_total.sum.to_s.rjust(8)
  print " total\n"
end

def output_stdin(files)
  line_count = files.chomp.count("\n")
  word = files.chomp.split(/\s+/)
  word_count = word.count
  letter_count = files.length

  print line_count.to_s.rjust(8)
  print word_count.to_s.rjust(8)
  print letter_count.to_s.rjust(8)
  print "\n"
end

def output_stdin_l_option(files)
  line_count = files.chomp.count("\n")
  print line_count.to_s.rjust(8)
  print "\n"
end

main(options)

