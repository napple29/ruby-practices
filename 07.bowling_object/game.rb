# frozen_string_literal: true

require_relative './frame'

class Game

  def initialize(all_marks)
    @all_marks = all_marks
    frames = Frame.divide_frames(all_marks)
    @frames = frames.map.with_index do |frame, index|
      Frame.new(index, *frame)
    end
  end

  def total_score
    @frames.map.with_index do |frame, index|
      frame.calc_score(@frames[index.next], @frames[index.next.next])
    end.sum
  end
end

all_marks = ARGV[0].split(',')
game = Game.new(all_marks)
puts game.total_score
