# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

require_relative './detail'

class LsCommand
  def initialize(options)
    options
  end

  def main(options)
    files = options['a'] ? Detail.all_files : Detail.not_begin_with_a_dot_files
    files = options['r'] ? Detail.reverse_files(files) : files

    if options['l']
      Detail.output_long_option(files)
    else
      Detail.output_nomal_option(files)
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
ls_command = LsCommand.new(options)
ls_command.main(options)
