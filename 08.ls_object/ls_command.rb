# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'
require_relative './option'
require_relative './file'

class LsCommand
  include Options

  def initialize
    # @options = options
    @file = File.new
    p @file
    # @options = options #[["a", true], ["l", true], ["r", false]]
    # *a_option = options.find_all{|n| n.include?("a")} #["a", true]
    # p *a_option
    # @file = File.new
    # @sort = Sort.new
    # @column = Column.new
  end

  def foo
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

# options = ARGV.getopts('a', 'l', 'r')
LsCommand.new
