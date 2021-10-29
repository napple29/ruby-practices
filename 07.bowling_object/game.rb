# frozen_string_literal: true

require_relative './frame'

class Game
  attr_reader :all_shots, :frames

  def initialize(all_shots)
    @all_shots = all_shots
    frames = Frame.divide_frames(all_shots)
    @frames = frames.map.with_index do |frame, index|
      Frame.new(index, *frame)
    end
  end

  def total_score
    @frames.map.with_index do |frame, index|
      frame.calc_score(@frames[index.succ], @frames[index.succ.succ])
    end.sum
  end
end

all_shots = ARGV[0]
game = Game.new(all_shots)
puts game.total_score
