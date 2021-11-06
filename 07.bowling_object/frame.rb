# frozen_string_literal: true

require_relative './shot'

class Frame
  attr_accessor :first_shot, :second_shot, :third_shot, :index

  def initialize(index, first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
    @index = index
  end

  def calc_score(next_frame, after_next_frame)
    if last_frame?
      basic_score
    elsif strike?
      basic_score + strike_bonus(next_frame, after_next_frame)
    elsif spare?
      basic_score + spare_bonus(next_frame)
    else
      basic_score
    end
  end

  def self.divide_frames(all_marks)
    frames = []
    shots = []
    last_frame_shots = []
    index = 0

    all_marks.each do |mark|
      shot = Shot.new(mark)
      shots << shot
      if frames.size < 9
        if shots.size >= 2 || mark == 'X'
          frames << Frame.new(index, *shots)
          index += 1
          shots.clear
        end
      else
        last_frame_shots << shot
      end
    end
    frames << Frame.new(index, *last_frame_shots)
    frames
  end

  def last_frame?
    @index == 9
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    [@first_shot.score, @second_shot.score].sum == 10 && !strike?
  end

  def basic_score
    [@first_shot.score, @second_shot&.score, @third_shot&.score].compact.sum
  end

  def strike_bonus(next_frame, after_next_frame)
    if next_frame.strike? && !next_frame.last_frame?
      next_frame.first_shot.score + after_next_frame.first_shot.score
    else
      next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def spare_bonus(next_frame)
    next_frame.first_shot.score
  end
end
