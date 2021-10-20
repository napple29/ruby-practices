# frozen_string_literal: true

class Shot
  def convert_to_shots
    shots = ARGV[0]
    shots.split(',').map { |shot| shot == 'X' ? '10'.to_i : shot.to_i }
  end
end
