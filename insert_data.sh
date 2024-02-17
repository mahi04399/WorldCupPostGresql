#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

query(){
  echo $($PSQL "$1")
}

query "TRUNCATE games, teams;";

# Do not change code above this line. Use the PSQL variable above to query your database.
isAtTop=1;
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [ $isAtTop -eq 0 ]
  then
    WINNER_TEAM_ID=$(query "select team_id from teams where name = '$WINNER';");
    OPPONENT_TEAM_ID=$(query "select team_id from teams where name = '$OPPONENT';");
    
    # insert and get team IDs
    if [[ -z $WINNER_TEAM_ID ]]
    then
      query "insert into teams(name) values('$WINNER');"
      WINNER_TEAM_ID=$(query "select team_id from teams where name = '$WINNER';")
    fi

    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      query "insert into teams(name) values('$OPPONENT');"
      OPPONENT_TEAM_ID=$(query "select team_id from teams where name = '$OPPONENT';");
    fi
    
    # insert game
    query "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
            values($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
  isAtTop=0
done

