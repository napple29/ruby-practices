require 'optparse'
require_relative './file'

class Sort
  def initialize(options)
    @files = File.new(options).instance_variable_get(:@files)
    @sort_files = sort_files(options)
  end
  def sort_files(options)
    options['r'] ? @files.reverse : @files 
  end
end
