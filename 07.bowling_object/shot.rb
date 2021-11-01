# frozen_string_literal: true

class Shot
  attr_accessor :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 0 if mark.nil?

    mark.mark == 'X' ? 10 : mark.mark.to_i
  end
end
