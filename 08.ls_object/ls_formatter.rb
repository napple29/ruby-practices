# frozen_string_literal: true

require 'fileutils'
require 'etc'

require_relative './ls_file'

class LsFormatter
  attr_reader :all_files

  def initialize
    @all_files = all_files
  end

  def all_files
    Dir.glob('*', File::FNM_DOTMATCH).map{|file| LsFile.new(file)}
  end

  def not_begin_with_a_dot_files
    all_files.delete_if{|file| file.name.match(/^[.]/)}
  end

  def reverse_files(files)
    files.reverse
  end

  def files_name(files)
    files.map{|file| file.name}
  end

  def output_default_format(files)
    files_name_list = files_name(files)

    column = 3
    line = if ( files_name_list.size % column).zero?
               files_name_list.size / column
            else
               files_name_list.size / column + 1
            end

    divide_by_columns =  files_name_list.each_slice(line).to_a

    unless divide_by_columns.last.size == divide_by_columns.first.size
      (divide_by_columns.first.size - divide_by_columns.last.size).times { divide_by_columns.last.push('') }
    end

    divide_by_columns.transpose.each do |divide_by_column|
      divide_by_column.each_with_index do |file, idx|
        print file.ljust(20)
        print "\n" if ((idx + 1) % column).zero?
        print "\n" if idx == divide_by_columns.flatten.size - 1
      end
    end
  end

  def output_list_in_long_format(files)
    file_total(files)
    list_in_long_format(files)
  end

  def file_total(files)
    total = files.map {|file| file.file_block}.sum
    puts "total #{total}"
  end

  def list_in_long_format(files)
    files.each do |file|
      print file.file_mode.ljust(9)
      print file.number_of_links.to_s.rjust(3, ' ')
      print file.owner_name.rjust(13)
      print file.group_name.rjust(6)
      print file.number_of_bytes_in_the_file.to_s.rjust(5, ' ')
      print file.last_modified_time.rjust(13)
      print ' ' + file.name
      print "\n"
    end
  end
end
