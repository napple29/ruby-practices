# frozen_string_literal: true

require 'optparse'

def main(options) 
  if ARGV[0]
    files = ARGV
    output_files(files, options)
  else
    text = $stdin.read
    output_stdin(text, options)
  end
end

DEFAULT_WIDTH = 8

def output_files(files, options)
  line_total = []
  word_total = []
  byte_size_total = []
  files.each do |file|
    file_text = File.read(file)
    line_count = count_line(file_text)
    word_count = count_word(file_text)
    byte_size = count_byte_size(file_text)
    line_total << line_count
    word_total << word_count
    byte_size_total << byte_size
    print_values(line_count, word_count, byte_size, options)
    print " #{file}\n"
  end
  return if files.size == 1

  print_values_sum(line_total, word_total, byte_size_total, options)
  print " total\n"
end

def print_values(line_count, word_count, byte_size, options)
  print line_count.to_s.rjust(DEFAULT_WIDTH)
  return if options['l']

  print word_count.to_s.rjust(DEFAULT_WIDTH)
  print byte_size.to_s.rjust(DEFAULT_WIDTH)
end

def print_values_sum(line_total, word_total, byte_size_total, options)
  print line_total.sum.to_s.rjust(DEFAULT_WIDTH)
  return if options['l']

  print word_total.sum.to_s.rjust(DEFAULT_WIDTH)
  print byte_size_total.sum.to_s.rjust(DEFAULT_WIDTH)
end

def count_line(text)
  text.lines.size
end

def count_word(text)
  text.split(/\s+/).count
end

def count_byte_size(text)
  text.length
end

def output_stdin(text, options)
  line_count = count_line(text)
  word_count = count_word(text)
  byte_size = count_byte_size(text)

  print_values(line_count, word_count, byte_size, options)
  print "\n"
end

options = ARGV.getopts('l')
main(options)

