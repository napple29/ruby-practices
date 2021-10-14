class Shot 
  def shots
    shot = ARGV[0]
    shots =  shot.split(',')
    scores = shots.map{|shot| shot == 'X' ? '10'.to_i : shot.to_i}
  end
end
