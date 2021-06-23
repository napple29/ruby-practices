# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

def main(options)
  use_files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  files = options['r'] ? use_files.sort.reverse : use_files

  if options['l']
    file_total
    files.each do |file|
      puts l_option(file)
    end
  else
    no_option(files)
  end
end

def file_total
  total = []
  Dir.foreach('.') do |item|
    total << File.stat(item).blksize / 512
  end
  puts "total #{total.sum}"
end

def l_option(file)
  fs = File::Stat.new(file)
  mode_num = fs.mode.to_s(8).rjust(6, '0')
  filetype_num = mode_num[0..1]
  permissions_num = mode_num[3..5]
  filetype = convert_to_filetype(filetype_num)
  owner_permission = convert_to_permissions(permissions_num[0])
  group_permission = convert_to_permissions(permissions_num[1])
  other_permission = convert_to_permissions(permissions_num[2])
  user = Etc.getpwuid(fs.uid).name
  group = Etc.getgrgid(fs.gid).name
  hardlink = fs.nlink
  base = File.basename(file)
  print "#{filetype}#{owner_permission}#{group_permission}#{other_permission}\t#{hardlink}\t#{group}\t#{user}\t#{File.size(file)}#{File.ctime(file)}#{base}\t"
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

def no_option(file)
  slice_number = if (file.size % 3).zero?
                   file.size / 3
                 else
                   file.size / 3 + 1
                 end
  sliced_file = []
  file.each_slice(slice_number) { |s| sliced_file << s }
  (sliced_file.first.length - sliced_file.last.length).times { sliced_file.last.push('') } unless sliced_file.last.length == sliced_file.first.length
  transposed_sliced_file = sliced_file.transpose
  transposed_sliced_file.max_by(&:length)
  num_for_spaces = file.max_by(&:size).size + 10
  transposed_sliced_file.each do |ary|
    print ary[0] + ' ' * (num_for_spaces - ary[0].size)
    print ary[1] + ' ' * (num_for_spaces - ary[1].size)
    print ary[2]
    print "\n"
  end
end

options = ARGV.getopts('a', 'l', 'r')
main(options)

