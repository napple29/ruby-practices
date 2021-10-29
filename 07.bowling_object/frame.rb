# frozen_string_literal: true

require_relative './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :index

  def initialize(index, first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark).point
    @second_shot = Shot.new(second_mark).point
    @third_shot = Shot.new(third_mark).point
    @index = index
  end

  def calc_score(next_frame, after_next_frame)
    if last_frame?
      basic_point
    elsif strike?
      basic_point + strike_bonus(next_frame, after_next_frame)
    elsif spare?
      basic_point + spare_bonus(next_frame)
    else
      basic_point
    end
  end

  def self.divide_frames(all_shots)
    frames = []
    frame = []
    all_shots.split(',').each do |mark|
      score = Shot.new(mark).point
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
    @first_shot == 10
  end

  def spare?
    [@first_shot, @second_shot].sum == 10
  end

  def basic_point
    [@first_shot, @second_shot, @third_shot].sum
  end

  def smaller_second_to_last
    @index < 8
  end

  def strike_bonus(next_frame, after_next_frame)
    if next_frame_second_shot(next_frame).zero? && smaller_second_to_last
      next_frame_first_shot(next_frame) + after_next_frame_first_shot(after_next_frame)
    else
      next_frame_first_shot(next_frame) + next_frame_second_shot(next_frame)
    end
  end

  def spare_bonus(next_frame)
    next_frame_first_shot(next_frame)
  end

  def next_frame_first_shot(next_frame)
    next_frame.instance_variable_get('@first_shot')
  end

  def next_frame_second_shot(next_frame)
    next_frame.instance_variable_get('@second_shot')
  end

  def after_next_frame_first_shot(after_next_frame)
    after_next_frame.instance_variable_get('@first_shot')
  end
end
