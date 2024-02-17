#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

query(){
  echo $($PSQL "$1")
}

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo $(query "select sum(winner_goals) + sum(opponent_goals) as total_goals from games;")

echo -e "\nAverage number of goals in all games from the winning teams:"
echo $(query "select avg(winner_goals) as total_goals from games;")

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo $(query "select ROUND(avg(winner_goals), 2) as total_goals from games;")

echo -e "\nAverage number of goals in all games from both teams:"
echo $(query "select avg(winner_goals + opponent_goals) as total_goals from games;")

echo -e "\nMost goals scored in a single game by one team:"
echo $(query "select max(winner_goals) as max_goals from games;")

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo $(query "select count(*) from games where winner_goals > 2;")

echo -e "\nWinner of the 2018 tournament team name:"
echo $(query "select name from games inner join teams on games.winner_id=teams.team_id where round='Final' and year=2018;")


echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
query_output=$(query "select name from games inner join teams on (games.winner_id=teams.team_id OR games.opponent_id=teams.team_id) where round='Eighth-Final' And year=2014 order by name asc;")
echo "$query_output" | sed 's/\bCosta Rica\b/Costa_Rica/g; s/\United States\b/United_States/g; s/ /\n/g; s/United_States/United States/g; s/Costa_Rica/Costa Rica/g;'


echo -e "\nList of unique winning team names in the whole data set:"
query_output=$(query "select distinct(name) from games inner join teams on games.winner_id=teams.team_id order by name;")
echo "$query_output" | sed 's/\bCosta Rica\b/Costa_Rica/g; s/\United States\b/United_States/g; s/ /\n/g; s/United_States/United States/g; s/Costa_Rica/Costa Rica/g;'

echo -e "\nYear and team name of all the champions:"
query_output=$(query "select year, name from games inner join teams on games.winner_id=teams.team_id where round='Final' order by year")
echo "$query_output" | sed 's/\bCosta Rica\b/Costa_Rica/g; s/\United States\b/United_States/g; s/ /\n/g; s/United_States/United States/g; s/Costa_Rica/Costa Rica/g;'

echo -e "\nList of teams that start with 'Co':"
query_output=$(query "select name from teams where name like 'Co%';")
echo "$query_output" | sed 's/\bCosta Rica\b/Costa_Rica/g; s/\United States\b/United_States/g; s/ /\n/g; s/United_States/United States/g; s/Costa_Rica/Costa Rica/g;'
