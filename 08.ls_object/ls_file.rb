# frozen_string_literal: true

require 'fileutils'
require 'etc'

class LsFile
  FILETYPE = { '01': 'p', '02': 'c', '04': 'd', '06': 'b', '10': '-', '12': 'l', '14': 's' }.freeze
  PERMISSIONS = { '0': '---', '1': '--x', '2': '-w-', '3': '-wx', '4': 'r--', '5': 'r-x', '6': 'rw-', '7': 'rwx' }.freeze

  attr_reader :file, :fs

  def initialize(file)
    @file = file
    @fs = File::Stat.new(file)
  end

  def name
    File.basename(file)
  end

  def file_mode
    mode_num = fs.mode.to_s(8).rjust(6, '0')
    filetype_num = mode_num[0..1]
    permissions_num = mode_num[3..5]
    filetype = convert_to_filetype(filetype_num)
    owner_permission = convert_to_permissions(permissions_num[0])
    group_permission = convert_to_permissions(permissions_num[1])
    other_permission = convert_to_permissions(permissions_num[2])
    "#{filetype}#{owner_permission}#{group_permission}#{other_permission}"
  end

  def number_of_links
    fs.nlink
  end

  def owner_name
    Etc.getpwuid(fs.uid).name
  end

  def group_name
    Etc.getgrgid(fs.gid).name
  end

  def bytesize
    File.size(file)
  end

  def last_modified_time
    File.mtime(file)
  end

  def file_block
    File.stat(file).blocks
  end

  def convert_to_filetype(filetype_num)
    FILETYPE[filetype_num.to_sym]
  end

  def convert_to_permissions(permissions_num)
    PERMISSIONS[permissions_num.to_sym]
  end
end
