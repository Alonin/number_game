#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
ATTEMPTS=1
RUN_GAME(){
#echo "DEBUG:Number is $NUMBER"
read GUESS
if ! [[ $GUESS =~ $re ]]
then
echo "That is not an integer, guess again:"
RUN_GAME
else
if [[ $ATTEMPTS -lt $BEST ]] || [[ $GUESS == $NUMBER ]]
then
UPDATE_BEST=$($PSQL "UPDATE scores SET best_game=$ATTEMPTS WHERE username ='$USERNAME'")
echo "You guessed it in $ATTEMPTS tries. The secret number was $NUMBER. Nice job!"
GAMES=$(($GAMES + 1))
UPDATE_PLAYED=$($PSQL "UPDATE scores SET games_played=$GAMES WHERE username = '$USERNAME' ")
else
if [[ $GUESS == $NUMBER ]]
then
echo "You guessed it in $ATTEMPTS tries. The secret number was $NUMBER. Nice job!"
GAMES=$(($GAMES + 1))
UPDATE_PLAYED=$($PSQL "UPDATE scores SET games_played=$GAMES WHERE username = '$USERNAME' ")
else
if [[ $GUESS -lt $NUMBER ]]
then
echo "It's higher than that, guess again:"
ATTEMPTS=$(($ATTEMPTS + 1 ))
RUN_GAME
else
if [[ $GUESS -gt $NUMBER ]]
then
echo "It's lower than that, guess again:"
ATTEMPTS=$(($ATTEMPTS + 1 ))
RUN_GAME
fi
fi
fi
fi
fi

}


echo "Enter your username:"
read USERNAME

USERNAME_RESULT=$($PSQL "SELECT username FROM scores WHERE username = '$USERNAME'")
GAMES=$($PSQL "select games_played FROM scores WHERE username = '$USERNAME' ")
BEST=$($PSQL "select best_game FROM scores WHERE username = '$USERNAME' ")

NUMBER=$(( $RANDOM%1000 ))
re='^[0-9]+$'
if [[ -z $USERNAME_RESULT ]]
then 
INSERT_NEW_USER=$($PSQL "INSERT INTO scores(username, games_played, best_game) VALUES('$USERNAME', 0,1110)");
echo "Welcome, $USERNAME! It looks like this is your first time here."
echo  "Guess the secret number between 1 and 1000:"
RUN_GAME
else
echo "Welcome back, $USERNAME_RESULT! You have played $GAMES games, and your best game took $BEST guesses."
echo "Guess the secret number between 1 and 1000:"
RUN_GAME
 
fi
