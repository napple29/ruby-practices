# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

require_relative './file'
require_relative './detail'

class LsCommand

  def initialize(options)
    @files = Detail.new(options)
  end
end

options = ARGV.getopts('a', 'l', 'r')
LsCommand.new(options)
