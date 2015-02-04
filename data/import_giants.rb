#!/usr/bin/env ruby

require 'pg'

db = PG.connect(dbname: 'willcaltrainsucktoday')


File.open(ARGV[0]) do |file|
  file.each_line do |line|
    next if line.start_with? "START_DATE"
    date, time, _, teams, where = line.split(",")
    month, day, year = date.split("/")
    hour, minute, ampm = time.match("([0-9]+):([0-9]+) ([AP])M").captures
    hour = hour.to_i
    hour += 12 if hour < 12 && ampm == "P"
    who = teams.gsub(/Giants|at/, "").strip
    home = (where == "AT&T Park" || where == "O.co Coliseum")
    puts "20#{year}-#{month}-#{day}|#{hour}:#{minute}|#{who}|#{home} (#{where})"
    db.exec("INSERT INTO uw_giants_games
             (uw_year, uw_month, uw_day, uw_hour, uw_minute, uw_home, uw_who, uw_where) VALUES
             (20#{year}, #{month}, #{day}, #{hour}, #{minute}, #{home}, '#{who}', '#{where}')")
  end
end
