class File
  def initialize
    @files = file
    p @files #["detail.rb", "file.rb", "ls_command.rb", "option.rb"]
  end

  def file
    files = Dir.glob('*')
  end
end

# files = File.new
