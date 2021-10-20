# frozen_string_literal: true

class Shot
  def initialize(input_shots)
    @input_shots = input_shots
  end

  def shots
    @input_shots.split(',').map { |shot| shot == 'X' ? 10 : shot.to_i }
  end
end
