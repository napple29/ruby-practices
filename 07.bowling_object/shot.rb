# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def point
    return 10 if mark == 'X'
    mark.to_i
  end
end 
