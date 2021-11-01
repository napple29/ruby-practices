# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

require_relative './format'

class LsCommand
  def initialize(options)
    options
  end

  def main(options)
    files = options['a'] ? Format.all_files : Format.not_begin_with_a_dot_files
    files = options['r'] ? Format.reverse_files(files) : files

    if options['l']
      Format.output_long_option(files)
    else
      Format.output_nomal_option(files)
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
ls_command = LsCommand.new(options)
ls_command.main(options)
