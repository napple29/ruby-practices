# frozen_string_literal: true

require_relative './shot'

class Frame < Shot
  def shots_into_frame
    # shots = Shot.new
    # shots.convert_to_shots #[6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 6, 4, 5]
    frames = []
    frame = []
    convert_to_shots.each do |s|
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
