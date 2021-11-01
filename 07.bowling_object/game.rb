# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(all_marks)
    @all_marks = all_marks
    @frames = Frame.divide_frames(all_marks)
  end

  def total_score
    @frames.map.with_index do |frame, index|
      next_frame = Frame.new(index.next, *@frames[index.next]) if index < 9
      after_next_frame = Frame.new(index.next.next, *@frames[index.next.next]) if index < 8
      Frame.new(index, *frame).calc_score(next_frame, after_next_frame)
    end.sum
  end
end

all_marks = ARGV[0].split(',')
game = Game.new(all_marks)
puts game.total_score
