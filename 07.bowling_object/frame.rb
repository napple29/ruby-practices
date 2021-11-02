# frozen_string_literal: true

require_relative './shot'

class Frame
  attr_accessor :first_shot, :second_shot, :third_shot, :index

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
    shots = []
    index = -1 #インデックスを0から開始したいため
    all_marks.each do |mark|
      shot = Shot.new(mark)
      shots << shot
      if frames.size < 10
        if shots.size >= 2 || mark == 'X'
          index += 1
          frames << Frame.new(index, *shots)
          shots.clear
        end
      else # last frame
        if frames.last.second_shot.mark.nil?
          frames.last.second_shot.mark = shot
        else
          frames.last.third_shot.mark = shot
        end
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
