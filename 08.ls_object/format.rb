# frozen_string_literal: true

require 'fileutils'
require 'etc'

class Format
  def self.all_files
    Dir.glob('*', File::FNM_DOTMATCH)
  end

  def self.not_begin_with_a_dot_files
    Dir.glob('*')
  end

  def self.reverse_files(files)
    files.reverse
  end

  def self.output_nomal_option(files)
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

  def self.output_long_option(files)
    output_file_total(files)
    files.each do |file|
      long_option(file)
    end
  end

  protected

  def self.output_file_total(files)
    total = files.map { |one_file| File.stat(one_file).blocks }
    puts "total #{total.sum}"
  end

  def self.long_option(file)
    fs = File::Stat.new(file)
    mode_num = fs.mode.to_s(8).rjust(6, '0')
    filetype_num = mode_num[0..1]
    permissions_num = mode_num[3..5]
    filetype = convert_to_filetype(filetype_num)
    owner_permission = convert_to_permissions(permissions_num[0])
    group_permission = convert_to_permissions(permissions_num[1])
    other_permission = convert_to_permissions(permissions_num[2])
    hardlink = fs.nlink
    user = Etc.getpwuid(fs.uid).name
    group = Etc.getgrgid(fs.gid).name
    size = File.size(file)
    time = File.mtime(file).strftime('%m %d %k:%M')
    base = File.basename(file)
    puts "#{filetype}#{owner_permission}#{group_permission}#{other_permission}\t#{hardlink}\t#{user}\t#{group}\t#{size}\t#{time}\t#{base}\t"
  end

  def self.convert_to_filetype(filetype_num)
    {
      '01': 'p',
      '02': 'c',
      '04': 'd',
      '06': 'b',
      '10': '-',
      '12': 'l',
      '14': 's'
    } [filetype_num.to_sym]
  end

  def self.convert_to_permissions(permissions_num)
    {
      '0': '---',
      '1': '--x',
      '2': '-w-',
      '3': '-wx',
      '4': 'r--',
      '5': 'r-x',
      '6': 'rw-',
      '7': 'rwx'
    } [permissions_num.to_sym]
  end
end
