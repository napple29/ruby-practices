# frozen_string_literal: true

require_relative './frame'

class Game < Frame
  def calc_score_excepting_last_frame
    subtotal = 0
    frames[0..8].each.with_index(1) do |frame, index|
      subtotal +=
        if frame[0] == 10
          if frames[index][1]
            10 + frames[index][0] + frames[index][1]
          else
            10 + frames[index][0] + frames[index + 1][0]
          end
        elsif frame.sum == 10
          10 + frames[index][0]
        else
          frame.sum
        end
    end

    subtotal
  end

  def calc_last_frame
    frames[9].sum
  end

  def total_score
    calc_score_excepting_last_frame + calc_last_frame
  end
end

score = Game.new
puts score.total_score
