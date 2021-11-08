# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

require_relative './ls_formatter'

class LsCommand
  attr_reader :a_option, :l_option, :r_option, :current_directory_files

  def initialize(**options)
    @a_option = options['a']
    @l_option = options['l']
    @r_option = options['r']
    @current_directory_files = LsFormatter.new
  end

  def main
    files = a_option ? current_directory_files.all_files : current_directory_files.not_begin_with_a_dot_files
    files = r_option ? current_directory_files.reverse_files(files) : files

    if l_option
      current_directory_files.output_long_option(files)
    else
      current_directory_files.output_normal_option(files)
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
ls_command = LsCommand.new(**options)
ls_command.main
