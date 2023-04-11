#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "

echo -e "\n~~~~~ MY SALON ~~~~~\n"

 MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "$1"
  fi

  echo -e "\nHow can I help you?\n"

  SERVICES="$($PSQL "SELECT service_id, name FROM services")"
  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED =~ [0-9]+ ]]
  then
    SERVICE_ID_CHECK=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_ID_CHECK ]]
    then
      MAIN_MENU "\nI could not find that service. What would you like today?"
    else
      BOOK_SERVICE $SERVICE_ID_SELECTED;
    fi
  else
  MAIN_MENU "\nI could not find that service. What would you like today?"
  fi
}

 BOOK_SERVICE() { 
   SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo "$SERVICE_NAME"
  
  echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_ID ]]
        then
          # get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
            echo -e "\nWhat time would you like?"
           read SERVICE_TIME
           
        else
           CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
           echo -e "\nWhat time would you like?"
           read SERVICE_TIME
       fi
          CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
           echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
           INSERT_BOOK_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")
          
      


 }
EXIT() {
  echo -e "\nThank you for visit in.\n"
}

MAIN_MENU