class File
  attr_reader :files

  def initialize(options)
    @files = file(options)
  end

  def file(options)
    files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end
end

