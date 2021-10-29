# frozen_string_literal: true

require_relative './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :index

  def initialize(index, first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
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
    frame = []
    all_marks.each do |mark|
      score = Shot.new(mark).score
      frame << score
      if frames.size < 10
        if frame.size >= 2 || score == 10
          frames << frame.dup
          frame.clear
        end
      else # last frame
        frames.last << score
      end
    end
    frames
  end

  def last_frame?
    @index == 9
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    [@first_shot.score, @second_shot.score].sum == 10
  end

  def basic_score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def strike_bonus(next_frame, after_next_frame)
    if next_frame.second_shot == strike?
      next_frame.first_shot.score + after_next_frame.first_shot.score
    else
      next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def spare_bonus(next_frame)
    next_frame.first_shot.score
  end
end
