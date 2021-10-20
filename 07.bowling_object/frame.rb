# frozen_string_literal: true

require_relative './shot'

class Frame < Shot
  def frames
    frames = []
    frame = []
    shots.each do |s|
      frame << s
      if frames.size < 10
        if frame.size >= 2 || s == 10
          frames << frame.dup
          frame.clear
        end
      else # last frame
        frames.last << s
      end
    end
    frames
  end
end
