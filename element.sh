#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

ARGUMENT_ANSWER=$1

# if no argument is put into command line
if [[ -z $1 ]]
then 
  # display this line
  echo -e "Please provide an element as an argument."
else

# if is element answer
ELEMENT_ANSWER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ARGUMENT_ANSWER'")
if [[ $ELEMENT_ANSWER ]]
then 
  # get atomic_number
  ATOMIC_ANSWER=$ELEMENT_ANSWER
else 
  # if is symbol answer
  SYMBOL_ANSWER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ARGUMENT_ANSWER'")
  if [[ $SYMBOL_ANSWER ]]
  then
    # get atomic_number
    ATOMIC_ANSWER=$SYMBOL_ANSWER
  else
    # if is number answer
    NUMBER_ANSWER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$ARGUMENT_ANSWER'")
    if [[ $NUMBER_ANSWER ]]
    then
      # get atomic number
      ATOMIC_ANSWER=$NUMBER_ANSWER
    fi
  fi
fi

# if atomic_number doesn't exist
if [[ -z $ATOMIC_ANSWER ]]
then 
  # if atomic number doesn't exist display error
  echo -e "I could not find that element in the database."
else 
  # pull statement with element details
  JOIN_TABLE=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number='$ATOMIC_ANSWER' ORDER BY atomic_number")
  echo "$JOIN_TABLE" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
fi

fi
