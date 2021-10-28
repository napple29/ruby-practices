class Detail
  def initialize
    output_nomal_option(files)
  end
  def output_nomal_option(files)
    column = 3
    number = if (files.size % column).zero?
                     files.size / column
                   else
                     files.size / column + 1
                   end

     divide_file = files.each_slice(number).to_a

    unless divide_file.last.size == divide_file.first.size
      (divide_file.first.size - divide_file.last.size).times { divide_file.last.push('') }
    end
    between_files = files.max_by(&:size).size + 10

    divide_file.transpose.each do |files|
      files.each_with_index do |file, idx|
        print file + ' ' * (between_files - file.size)
        print "\n" if ((idx + 1) % column).zero?
      end
    end
  end
end
