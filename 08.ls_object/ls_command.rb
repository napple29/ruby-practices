# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'
require_relative './option.rb'

class LsCommand
  include Options

  def initialize(options)
    @options = options
    main(@options)
  end

  def main(options)
    files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')


    files = files.reverse if options['r'] 

    if options['l']
      output_file_total(files)
      files.each do |file|
        output_long_option(file)
      end
    else
      output_nomal_option(files)
    end
  end

end

options = ARGV.getopts('a', 'l', 'r')
LsCommand.new(options)
