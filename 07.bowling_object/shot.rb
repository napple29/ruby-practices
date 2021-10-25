# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end
  def score
    return 10 if mark == ʻXʼ
    mark.to_i
  end
end 

p Shot.new('9')
