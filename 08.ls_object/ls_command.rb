# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

require_relative './format'

class LsCommand
  attr_reader :a_option, :l_option, :r_option

  def initialize(**options)
    @a_option = options['a']
    @l_option = options['l']
    @r_option = options['r']
  end

  def main(**options)
    files = a_option ? Format.all_files : Format.not_begin_with_a_dot_files
    files = r_option ? Format.reverse_files(files) : files

    if l_option
      Format.output_long_option(files)
    else
      Format.output_nomal_option(files)
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
ls_command = LsCommand.new(**options)
ls_command.main
