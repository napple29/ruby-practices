# frozen_string_literal: true

require_relative './frame'

class Game

  attr_reader :all_shots

  def initialize(all_shots)
    @all_shots = all_shots
    frames = Frame.frames(all_shots)
    @frames = frames.map.with_index do |x, index|
      Frame.new(*x, index)
    end
  end

  def total_score
    @frames.map.with_index do |y, index|
      y.calc_score(all_shots, Frame.next_frame, Frame.after_next_frame)
    end.sum
  end
end

all_shots = ARGV[0]
game = Game.new(all_shots)
puts game.total_score
