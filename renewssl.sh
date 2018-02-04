#!/bin/bash

# ----------- UTILS FUNCTIONS -----------

# Printer with shell colors
function utils.printer {
    # BASH COLORS
    GREEN='\033[0;32m'
    RESET='\033[0m'
    echo -e "${GREEN}$(date +"%b %d %r") - $1${RESET}"
}

# Check service and PORT status
function utils.checkServicePortStatus {
    if [[ ! -z $1 ]] && [[ ! -z $2 ]]; then
        while [[ ! -z "$(lsof -i :$2)" ]]; do
            utils.printer "Waiting for stop $1 and free \"$2\" PORT"
            sleep 1
        done
    fi
}


# ------------ MAIN SCRIPT ---------------

# Set variables
WEB_SERVICE="nginx"
EMAIL_CERTBOT="user@domain.com"
DOMAINS_CERTBOT="-d domain1.com -d domain2.com -d domain3.com"
PORT="80"

utils.printer "-------------------------------------------------------------------------------"
utils.printer "Renew Certificate Job"
utils.printer "-------------------------------------------------------------------------------"

utils.printer "Step 0: Check configuration vars"
if [[ ! -z $WEB_SERVICE ]] && [[ ! -z $EMAIL_CERTBOT ]] && [[ ! -z $DOMAINS_CERTBOT ]] && [[ ! -z $PORT ]]; then
    utils.printer "Step 1: Stop $WEB_SERVICE service"
    sudo service $WEB_SERVICE stop
    utils.checkServicePortStatus $WEB_SERVICE $PORT

    utils.printer "Step 2: Create or renew certificates"
    utils.printer "Start cerbot service"
    certbot certonly --standalone --non-interactive --agree-tos --email=$EMAIL_CERTBOT $DOMAINS_CERTBOT
    utils.checkServicePortStatus certbot $PORT

    utils.printer "Step 3: Restart $WEB_SERVICE service"
    sudo service $WEB_SERVICE start
else
    utils.printer "Something is wrong, one ore more configuration vars are empty"
fi
