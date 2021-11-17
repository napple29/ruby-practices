# frozen_string_literal: true

require 'fileutils'
require 'etc'

require_relative './ls_file'

class LsFormatter
  COLUMN = 3

  attr_reader :ls_files

  def initialize(ls_files)
    @ls_files = ls_files
  end

  def output(l_option)
    if l_option
      output_list_in_long_format(ls_files)
    else
      output_default_format(ls_files)
    end
  end

  def output_default_format(ls_files)
    file_names = ls_files.map(&:name)

    line = (file_names.size.to_f / COLUMN).ceil

    divided_names_by_columns = file_names.each_slice(line).to_a

    unless divided_names_by_columns.last.size == divided_names_by_columns.first.size
      (divided_names_by_columns.first.size - divided_names_by_columns.last.size).times { divided_names_by_columns.last.push('') }
    end

    file_names_last_index = file_names.size - 1

    divided_names_by_columns.transpose.each do |divided_names_by_column|
      divided_names_by_column.each_with_index do |ls_file, idx|
        print ls_file.ljust(20)
        print "\n" if (idx.next % COLUMN).zero? || idx == file_names_last_index
      end
    end
  end

  def output_list_in_long_format(ls_files)
    output_total(ls_files)
    list_in_long_format(ls_files)
  end

  def output_total(ls_files)
    total = ls_files.map(&:file_block).sum
    puts "total #{total}"
  end

  def list_in_long_format(ls_files)
    ls_files.each do |ls_file|
      print ls_file.file_mode.ljust(9)
      print ls_file.number_of_links.to_s.rjust(3, ' ')
      print ls_file.owner_name.rjust(13)
      print ls_file.group_name.rjust(6)
      print ls_file.bytesize.to_s.rjust(5, ' ')
      print ls_file.last_modified_time.strftime('%m %d %k:%M').rjust(13)
      print ' '
      print ls_file.name
      print "\n"
    end
  end
end
