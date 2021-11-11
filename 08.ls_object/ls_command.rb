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
  end

  def main
    ls_files = Dir.glob('*', File::FNM_DOTMATCH).map { |ls_file| LsFile.new(ls_file) }
    ls_formatter = LsFormatter.new(ls_files)

    ls_files = ls_formatter.not_begin_with_a_dot_files unless a_option
    ls_files = ls_files.reverse if r_option

    if l_option
      ls_formatter.output_list_in_long_format(ls_files)
    else
      ls_formatter.output_default_format(ls_files)
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
ls_command = LsCommand.new(**options)
ls_command.main
