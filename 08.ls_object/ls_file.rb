# frozen_string_literal: true

require 'fileutils'
require 'etc'

class LsFile
  FILETYPE = { '01': 'p', '02': 'c', '04': 'd', '06': 'b', '10': '-', '12': 'l', '14': 's' }.freeze
  PERMISSIONS = { '0': '---', '1': '--x', '2': '-w-', '3': '-wx', '4': 'r--', '5': 'r-x', '6': 'rw-', '7': 'rwx' }.freeze

  attr_reader :file

  def initialize(file)
    @file = file
    @name = name
    @file_mode = file_mode
    @number_of_links = number_of_links
    @owner_name = owner_name
    @group_name = group_name
    @bytesize = bytesize
    @last_modified_time = last_modified_time
    @file_block = file_block
  end

  def self.ls_files
    Dir.glob('*', File::FNM_DOTMATCH).map { |file| LsFile.new(file) }
  end

  def name
    File.basename(file)
  end

  def file_mode
    fs = File::Stat.new(file)
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
    fs = File::Stat.new(file)
    fs.nlink
  end

  def owner_name
    fs = File::Stat.new(file)
    Etc.getpwuid(fs.uid).name
  end

  def group_name
    fs = File::Stat.new(file)
    Etc.getgrgid(fs.gid).name
  end

  def bytesize
    File.size(file)
  end

  def last_modified_time
    File.mtime(file).strftime('%m %d %k:%M')
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
