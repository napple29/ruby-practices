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

  def all_files_name
    all_files.map{|file| file.file}
  end

  def not_begin_with_a_dot_files_name
    all_files_name.grep(/^[^.]/)
  end

  def reverse_files(files)
    files.reverse
  end

  def output_normal_option(files)
    column = 3
    line = if (files.size % column).zero?
              files.size / column
            else
              files.size / column + 1
            end

    divide_by_columns = files.each_slice(line).to_a

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

  def output_long_option(files)
    output_file_total(files)
    files.each do |file|
      long_option(file)
    end
  end

  def output_file_total(files)
    total = files.map { |one_file| File.stat(one_file).blocks }
    puts "total #{total.sum}"
  end
end
