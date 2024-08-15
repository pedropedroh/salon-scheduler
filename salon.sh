#! /bin/bash

# SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME, and SERVICE_TIME

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "Welcome to My Salon, how can I help you?" 
  SALON_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
  echo "$SALON_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      # send to main menu
      MAIN_MENU "I could not find that service. What would you like today?"
    else
      # get bike availability
      SERVICE_AVAILABILITY=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      # if not available
      if [[ -z $SERVICE_AVAILABILITY ]]
      then
        # send to main menu
        MAIN_MENU "I could not find that service. What would you like today?"
      else
        # get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nI don't have a record for that phone number, what's your name?"
          read CUSTOMER_NAME
          # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
        fi
        SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        echo "What time would you like your $SERVICE_NAME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
        read SERVICE_TIME
        # get customer_id
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        # insert appoinment
        INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME');")
        echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
      fi
    fi
}

MAIN_MENU
