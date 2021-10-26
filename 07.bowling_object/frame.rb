# frozen_string_literal: true

require_relative './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil, index)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
    @index = index
  end

  def calc_score(all_shots, next_frame, after_next_frame)
    if last_frame?
      p basic_point
    elsif strike?
      p basic_point
      p 'ボーナス'
      p strike_bonus(all_shots, next_frame, after_next_frame)
      # p basic_point + strike_bonus(all_shots, next_frame, after_next_frame)
    elsif spare?
      p basic_point
      p 'ボーナス' 
      p spare_bonus(all_shots, next_frame)
      # p basic_point + spare_bonus(all_shots, next_frame)
    else
      p basic_point
    end
  end

  def self.frames(all_shots)
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
    @first_shot.point == 10
  end

  def spare?
    @first_shot.point + @second_shot.point == 10
  end

  def self.next_frame
     @index.to_i + 1
  end

  def self.after_next_frame
     @index.to_i + 2
  end

  def basic_point
    [@first_shot.point, @second_shot.point, @third_shot.point].sum
  end

  def strike_bonus(all_shots, next_frame, after_next_frame)
      if Frame.frames(all_shots)[next_frame][1].nil?
        p [Frame.frames(all_shots)[next_frame][0], Frame.frames(all_shots)[after_next_frame][0]].sum
      else
        p [Frame.frames(all_shots)[next_frame][0], Frame.frames(all_shots)[next_frame][1]].sum
      end
  end

  def spare_bonus(all_shots, next_frame)
    p Frame.frames(all_shots)[next_frame][0]
  end
end
