require 'fileutils'
require 'etc'

class LsFile

  attr_reader :file, :name, :permission, :hard_link, :file_user, :file_group, :file_size, :file_time, :file_block

  def initialize(file)
    @file = file
    @name = name
    @permission = permission
    @hard_link = hard_link
    @file_user = file_user
    @file_group = file_group
    @file_size = file_size
    @file_time = file_time
    @file_block = file_block
  end

  def name
    File.basename(file)
  end

  def permission
    fs = File::Stat.new(file)
    mode_num = fs.mode.to_s(8).rjust(6, '0')
    filetype_num = mode_num[0..1]
    permissions_num = mode_num[3..5]
    filetype = convert_to_filetype(filetype_num)
    owner_permission = convert_to_permissions(permissions_num[0])
    group_permission = convert_to_permissions(permissions_num[1])
    other_permission = convert_to_permissions(permissions_num[2])
    "#{owner_permission}#{group_permission}#{other_permission}"
  end

  def hardlink
    fs = File::Stat.new(file)
    fs.nlink
  end

  def file_user
    fs = File::Stat.new(file)
    Etc.getpwuid(fs.uid).name
  end

  def file_group
    fs = File::Stat.new(file)
    Etc.getgrgid(fs.gid).name
  end

  def file_size
    File.size(file)
  end

  def file_time
    File.mtime(file).strftime('%m %d %k:%M')
  end

  def file_block
    File.stat(file).blocks
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
      }[filetype_num.to_sym]
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
      }[permissions_num.to_sym]
    end
end
