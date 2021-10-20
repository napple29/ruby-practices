require_relative './frame.rb'

class Game < Frame
  def calc_score

    total = 0
    shots_into_frame[0..8].each.with_index(1) do |frame, index|
      total += 
        if frame[0] == 10
          shots_into_frame[index][1]? 10 + shots_into_frame[index][0] + shots_into_frame[index][1] : 10 + game.shots_into_frame[index][0] + game.shots_into_frame[index + 1][0]
        elsif frame.sum == 10
          10 + shots_into_frame[index][0]
        else
          frame.sum
        end
    end

    total
  end

  def calc_score2
    total = shots_into_frame[9].sum
  end

  def total_score
    calc_score + calc_score2
  end
end

score = Game.new
puts score.total_score
