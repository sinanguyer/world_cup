#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams,games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  TEAMS=$($PSQL "select name from teams where name='$WINNER'")
  if [[ $WINNER != 'winner' ]]
    then
    if [[ -z $TEAMS ]]
      then
      INSERT_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
       if [[ INSERT_TEAM == "INSERT 0 1" ]]
       then
         echo Inserted into teams, $WINNER
       fi
     fi
  fi
  
  TEAMS_L=$($PSQL "select name from teams where name='$OPPONENT'")
  if [[ $OPPONENT != 'opponent' ]]
     then
     if [[ -z $TEAMS_L ]]
       then
       INSERT_TEAM_L=$($PSQL "insert into teams(name) values('$OPPONENT')")
       if [[ $INSERT_TEAM_L == "INSERT 0 1" ]]
       then
         echo Inserted into teams, $OPPONENT
       fi
     fi
  fi

  TEAM_ID_W=$($PSQL "select team_id from teams where name='$WINNER'")
  TEAM_ID_O=$($PSQL "select team_id from teams where name='$OPPONENT'")
  if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]]
  then
    if [[ $YEAR != "year" ]]
    then
       INSERT_GAMES=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', '$TEAM_ID_W', '$TEAM_ID_O', '$WINNER_GOALS', '$OPPONENT_GOALS')")
       if [[ $INSERT_GAMES == "INSERT 0 1" ]]
       then
         echo Inserted into games, $YEAR
       fi  
    fi 
  fi  








done