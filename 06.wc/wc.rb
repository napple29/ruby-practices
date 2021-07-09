# frozen_string_literal: true

require 'optparse'

DEFAULT_WIDTH = 8

def main
  options = ARGV.getopts('l')
  if ARGV.empty?
    text = $stdin.read
    output_stdin(text, options)
  else
    files = ARGV
    output_files(files, options)
  end
end

def output_files(files, options)
  line_total = 0
  word_total = 0
  byte_size_total = 0
  files.each do |file|
    file_text = File.read(file)
    line_count = count_line(file_text)
    word_count = count_word(file_text)
    byte_size = count_byte_size(file_text)
    line_total += line_count
    word_total += word_count
    byte_size_total += byte_size
    print_values(line_count, word_count, byte_size, options)
    print " #{file}\n"
  end
  return if files.size == 1

  print_values(line_total, word_total, byte_size_total, options)
  print " total\n"
end

def print_values(line_count, word_count, byte_size, options)
  print format_value(line_count)
  return if options['l']

  print format_value(word_count)
  print format_value(byte_size)
end

def format_value(value)
  value.to_s.rjust(DEFAULT_WIDTH)
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

main

