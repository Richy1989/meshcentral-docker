#!/bin/bash


run_mesh()
{
    chown node:node -R /opt/meshcentral
    #run as node user
    if [ $1 ]; then
        su -c "node meshcentral/meshcentral --configfile \"${CONFIG_FILE}\" ${2}" node
    else
        su -c "node meshcentral/meshcentral --configfile \"${CONFIG_FILE}\" --cert "$HOSTNAME" ${2}" node
    fi
    
    # su -c "node meshcentral/meshcentral --configfile \"${CONFIG_FILE}\" ${ARGS}" node
    # su -c "$1" node
}

if [ -f "meshcentral-data/${CONFIG_FILE}" ] && [ "$FORCE_CREATE_CONFIG" = "false" ]; then
    run_mesh true ${ARGS}
    #node meshcentral/meshcentral --configfile "${CONFIG_FILE}" ${ARGS}
else
    rm -f meshcentral-data/"${CONFIG_FILE}"
    cp config.json.template meshcentral-data/"${CONFIG_FILE}"
    
    if [ -n "$USE_MONGODB" ] && [ "$USE_MONGODB" == "true" ]; then
        if [ -z "$MONGO_URL" ]; then
            prefix=""
            if [ -n "$MONGO_INITDB_ROOT_USERNAME" ] && [ -n "$MONGO_INITDB_ROOT_PASSWORD" ]; then
                prefix="$MONGO_INITDB_ROOT_USERNAME:$MONGO_INITDB_ROOT_PASSWORD@"
            fi
            MONGO_URL="${prefix}mongodb:27017"
        fi
        # sed -i "s/\"_mongoDb\": null/\"mongodb:\/\/$MONGO_URL\"/" meshcentral-data/"${CONFIG_FILE}"
        sed -i "s|\"_mongoDb\": null|\"mongodb\": \"$MONGO_URL\"|" meshcentral-data/"${CONFIG_FILE}"
    fi
    sed -i "s/\"cert\": \"myserver.mydomain.com\"/\"cert\": \"$HOSTNAME\"/" meshcentral-data/"${CONFIG_FILE}"
    sed -i "s/\"NewAccounts\": true/\"NewAccounts\": $ALLOW_NEW_ACCOUNTS/" meshcentral-data/"${CONFIG_FILE}"
    sed -i "s/\"enabled\": false/\"enabled\": $ALLOWPLUGINS/" meshcentral-data/"${CONFIG_FILE}"
    sed -i "s/\"localSessionRecording\": false/\"localSessionRecording\": $LOCALSESSIONRECORDING/" meshcentral-data/"${CONFIG_FILE}"
    sed -i "s/\"minify\": true/\"minify\": $MINIFY/" meshcentral-data/"${CONFIG_FILE}"
    sed -i "s/\"WebRTC\": false/\"WebRTC\": $WEBRTC/" meshcentral-data/"${CONFIG_FILE}"
    sed -i "s/\"AllowFraming\": false/\"AllowFraming\": $IFRAME/" meshcentral-data/"${CONFIG_FILE}"
    if [ -z "$SESSION_KEY" ]; then
        SESSION_KEY="$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 48 | head -n 1)"
    fi
    sed -i "s/\"_sessionKey\": \"MyReallySecretPassword1\"/\"sessionKey\": \"$SESSION_KEY\"/" meshcentral-data/"${CONFIG_FILE}"
    if [ "$REVERSE_PROXY" != "false" ]; then
        sed -i "s/\"_certUrl\": \"my\.reverse\.proxy\"/\"certUrl\": \"https:\/\/$REVERSE_PROXY:$REVERSE_PROXY_TLS_PORT\"/" meshcentral-data/"${CONFIG_FILE}"
        run_mesh true ${ARGS}
        exit
    fi
    #node meshcentral/meshcentral --configfile "${CONFIG_FILE}" --cert "$HOSTNAME" ${ARGS}
    run_mesh false ${ARGS}
fi
