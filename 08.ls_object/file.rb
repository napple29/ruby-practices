# frozen_string_literal: true

class File
  
  attr_accessor :files

  def initialize(options)
    @files = files(options)
  end

  def files(options)
    options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end
end
