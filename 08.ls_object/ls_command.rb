# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

require_relative './ls_formatter'

class LsCommand
  attr_reader :a_option, :l_option, :r_option, :ls_formatter

  def initialize(**options)
    @a_option = options['a']
    @l_option = options['l']
    @r_option = options['r']
    @ls_formatter = LsFormatter.new(LsFile.ls_files)
  end

  def main
    files = a_option ? ls_formatter.ls_files : ls_formatter.not_begin_with_a_dot_files
    files = r_option ? ls_formatter.reverse_files(files) : files

    if l_option
      ls_formatter.output_list_in_long_format(files)
    else
      ls_formatter.output_default_format(files)
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
ls_command = LsCommand.new(**options)
ls_command.main
