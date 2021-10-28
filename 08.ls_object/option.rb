# frozen_string_literal: true

# require 'fileutils'
# require 'etc'

module Options
  def output_file_total(file)
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

  def output_nomal_option(files)
    column = 3
    number = if (files.size % column).zero?
                     files.size / column
                   else
                     files.size / column + 1
                   end

     divide_file = files.each_slice(number).to_a

    unless divide_file.last.size == divide_file.first.size
      (divide_file.first.size - divide_file.last.size).times { divide_file.last.push('') }
    end
    between_files = files.max_by(&:size).size + 10

    divide_file.transpose.each do |files|
      files.each_with_index do |file, idx|
        print file + ' ' * (between_files - file.size)
        print "\n" if ((idx + 1) % column).zero?
      end
    end
  end
end
