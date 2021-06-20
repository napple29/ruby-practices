# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores[0..-4].each do |s| # [0..-4]は10フレーム目を除いて、最後にストライクが起こりうる投球
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
frames = shots.each_slice(2).to_a

if frames[10]
  frames[9] += frames[10]
  frames.delete_at(10)
end

point = 0

frames[0..7].each_with_index do |frame, n| # n = index
  point += if frame[0] == 10 && (frames[n + 1][1]).zero? # strike
             frames[n + 2][0] + 20
           elsif frame[0] == 10 && frames[n + 1][1] != 0
             frames[n + 1].sum + 10
           elsif frames[n].sum == 10 # spare
             frames[n + 1][0] + 10
           else
             frames[n].sum
           end
end

point += if frames[8][0] == 10 # strike
           frames[9][0..1].sum + 10
         elsif frames[8].sum == 10 # spare
           frames[9][0] + 10
         else
           frames[8].sum
end

point += frames[9].sum

puts point

