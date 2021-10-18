class Shot 
  def convert_to_shots
    shot = ARGV[0]
    shots = shot.split(',').map{|shot| shot == 'X' ? '10'.to_i : shot.to_i}
  end
end
