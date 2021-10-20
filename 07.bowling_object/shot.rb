# frozen_string_literal: true

class Shot
  def shots
    input_shots = ARGV[0]
    input_shots.split(',').map { |shot| shot == 'X' ? '10'.to_i : shot.to_i }
  end
end
