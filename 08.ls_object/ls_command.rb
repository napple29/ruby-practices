# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

require_relative './ls_formatter'

class LsCommand
  attr_reader :a_option, :l_option, :r_option

  def initialize(options)
    @a_option = options['a']
    @l_option = options['l']
    @r_option = options['r']
  end

  def main
    glob_option = a_option ? File::FNM_DOTMATCH : 0
    ls_files = Dir.glob('*', glob_option).map { |ls_file| LsFile.new(ls_file) }

    ls_files = ls_files.reverse if r_option

    ls_formatter = LsFormatter.new(ls_files)

    ls_formatter.output(long_format: l_option)
  end
end

options = ARGV.getopts('a', 'l', 'r')
ls_command = LsCommand.new(options)
ls_command.main
