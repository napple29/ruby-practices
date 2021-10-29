require 'optparse'
require_relative './file'

class Sort
  def initialize(files)
    @sort_files = sort_files(files)
  end

  def sort_files(files)
    files.reverse
  end
end
