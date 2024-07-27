#!/bin/bash

export NODE_ENV=production

export HOSTNAME
export REVERSE_PROXY
export REVERSE_PROXY_TLS_PORT
export IFRAME
export ALLOW_NEW_ACCOUNTS
export WEBRTC

export TITLE
export SERVERNAME

export MONGODB_URI

export FORCE_CREATE_CONFIG

create_config_start() {
        cp config.json.template meshcentral-data/config.json
        sed -i "s/\"cert\": \"myserver.mydomain.com\"/\"cert\": \"$HOSTNAME\"/" meshcentral-data/config.json
        sed -i "s/\"NewAccounts\": true/\"NewAccounts\": $ALLOW_NEW_ACCOUNTS/" meshcentral-data/config.json
        sed -i "s/\"WebRTC\": false/\"WebRTC\": $WEBRTC/" meshcentral-data/config.json
        sed -i "s/\"AllowFraming\": false/\"AllowFraming\": $IFRAME/" meshcentral-data/config.json
        sed -i "s|\"mongodb\": \"mongodb://mongodb:27017/mesh\"|\"mongodb\": \"$MONGODB_URI\"|" meshcentral-data/config.json
        sed -i "s/\"_title\": \"MyServer\"/\"_title\": \"$TITLE\"/" meshcentral-data/config.json
        sed -i "s/\"_title2\": \"Servername\"/\"_title2\": \"$SERVERNAME\"/" meshcentral-data/config.json
        if [ -z "$SESSION_KEY" ]; then
        SESSION_KEY="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w 32 | head -n 1)"
        fi
        sed -i "s/\"_sessionKey\": \"MyReallySecretPassword1\"/\"sessionKey\": \"$SESSION_KEY\"/" meshcentral-data/config.json
        if [ "$REVERSE_PROXY" != false ]
            then 
                sed -i "s/\"_certUrl\": \"my\.reverse\.proxy\"/\"certUrl\": \"https:\/\/$REVERSE_PROXY:$REVERSE_PROXY_TLS_PORT\"/" meshcentral-data/config.json
                sed -i "s/\"TLSOffload\": false/\"TLSOffload\": \"$REVERSE_PROXY\"/" meshcentral-data/config.json
                node node_modules/meshcentral
                exit
        fi
        node node_modules/meshcentral --cert "$HOSTNAME" 
}

if [ "$FORCE_CREATE_CONFIG" = false ]; then
    if [ -f "meshcentral-data/config.json" ]
        then
            node node_modules/meshcentral 
        else
            create_config_start
    fi
else
    rm -f meshcentral-data/config.json
    create_config_start
fi
