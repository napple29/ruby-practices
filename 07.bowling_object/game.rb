require_relative './frame.rb'

class Game
  def calc_score
    game = Frame.new

    total = 0
    game.shots_into_frame[0..8].each.with_index(1) do |frame, index|
      if frame[0] == 10
        if game.shots_into_frame[index][1]
          total += 10 + game.shots_into_frame[index][0] + game.shots_into_frame[index][1] #２投続けてストライクだとエラーになる
        elsif game.shots_into_frame[index][1].nil?
          total += 10 + game.shots_into_frame[index][0] + game.shots_into_frame[index + 1][0]
        end
      elsif frame.sum ==10
        total += 10 + game.shots_into_frame[index][0]
      else
        total += frame.sum
      end
    end

    total
  end

  def calc_score2
    game = Frame.new
    total = game.shots_into_frame[9].sum
  end

  def total_score
    calc_score.to_i + calc_score2.to_i
  end
end

score = Game.new
puts score.total_score
