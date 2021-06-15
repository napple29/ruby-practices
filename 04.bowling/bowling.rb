# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores[0..-4].each do |s|
  if s == 'X' # strike
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

scores[-3..].each do |s|
  shots << if s == 'X' # strike
             10
           else
             s.to_i
           end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

if frames[10]
  frames[9] += frames[10]
  frames.delete_at(10)
end

point = 0

frames[0..7].each_with_index do |frame, n| # n = index
  if frame[0] == 10 && (frames[n + 1][1]).zero? # strike
    point = point + frames[n + 2][0] + 20
  elsif frame[0] == 10 && frames[n + 1][1] != 0
    point = point + frames[n + 1].sum + 10
  elsif frames[n].sum == 10 # spare
    point = point + frames[n + 1][0] + 10
  else
    point += frames[n].sum
  end
end

if frames[8][0] == 10 # strike
  point = point + frames[9][0..1].sum + 10
elsif frames[8].sum == 10 # spare
  point = point + frames[9][0] + 10
else
  point += frames[8].sum
end

point += frames[9].sum

puts point

