# frozen_string_literal: true

require 'optparse'
require_relative './file'

class Sort

  attr_accessor :sort_files

  def initialize(files)
    @sort_files = sort_files(files)
  end

  def sort_files(files)
    files.reverse
  end
end
