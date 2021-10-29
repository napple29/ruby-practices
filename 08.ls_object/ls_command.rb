# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

require_relative './file'
require_relative './sort'
require_relative './detail'

class LsCommand
  def initialize(options)
    files = File.new(options)
    @files = files.files(options)
  end

  def main(options)

  files = options['r']? Sort.new(@files) : @files

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
