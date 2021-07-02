# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

def main(options)
  files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  files = files = files.reverse if options['r'] 

  if options['l']
    output_file_total(files)
    files.each do |file|
      output_long_option(file)
    end
  else
    output_nomal_option(files)
  end
end

def output_file_total(file)
  total = []
  total = file.map { |one_file| File.stat(one_file).blocks }
  puts "total #{total.sum}"
end

def output_long_option(file)
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

def convert_to_filetype(filetype_num)
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

def convert_to_permissions(permissions_num)
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

def output_nomal_option(file)
  line = 3
  slice_number = if (file.size % line).zero?
                   file.size / line
                 else
                   file.size / line + 1
                 end
  sliced_file = file.each_slice(slice_number).to_a
  (sliced_file.first.length - sliced_file.last.length).times { sliced_file.last.push('') } unless sliced_file.last.length == sliced_file.first.length
  transposed_sliced_file = sliced_file.transpose
  num_for_spaces = file.max_by(&:size).size + 10
  transposed_sliced_file.each do |ary|
    ary.each_with_index do |element, idx|
      print element + ' ' * (num_for_spaces - element.size)
      print "\n" if ((idx + 1) % line).zero?
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
main(options)

