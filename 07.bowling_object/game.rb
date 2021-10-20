# frozen_string_literal: true

require_relative './frame'

class Game < Frame
  def calc_score
    subtotal = 0
    shots_into_frame[0..8].each.with_index(1) do |frame, index|
      subtotal +=
        if frame[0] == 10
          if shots_into_frame[index][1]
            10 + shots_into_frame[index][0] + shots_into_frame[index][1]
          else
            10 + shots_into_frame[index][0] + shots_into_frame[index + 1][0]
          end
        elsif frame.sum == 10
          10 + shots_into_frame[index][0]
        else
          frame.sum
        end
    end

    subtotal
  end

  def calc_score2
    shots_into_frame[9].sum
  end

  def total_score
    calc_score + calc_score2
  end
end

score = Game.new
puts score.total_score
