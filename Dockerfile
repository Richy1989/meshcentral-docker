FROM --platform=$BUILDPLATFORM node:20-alpine AS builder

RUN mkdir -p /opt/meshcentral/meshcentral

#Copy MeshCentral into the build, we get this by checking it out of the official repo, this happens in the GitAction
COPY ./mesh /opt/meshcentral/meshcentral/

WORKDIR /opt/meshcentral

ARG DISABLE_MINIFY=""
ARG DISABLE_TRANSLATE=""

RUN if ! [ -z "$DISABLE_MINIFY" ] && [ "$DISABLE_MINIFY" != "yes" ] && [ "$DISABLE_MINIFY" != "YES" ] \
    && [ "$DISABLE_MINIFY" != "true" ] && [ "$DISABLE_MINIFY" != "TRUE" ]; then \
    echo -e "\e[0;31;49mInvalid value for build argument DISABLE_MINIFY, possible values: yes/true\e[;0m"; exit 1; \
    fi
RUN if ! [ -z "$DISABLE_TRANSLATE" ] && [ "$DISABLE_TRANSLATE" != "yes" ] && [ "$DISABLE_TRANSLATE" != "YES" ] \
    && [ "$DISABLE_TRANSLATE" != "true" ] && [ "$DISABLE_TRANSLATE" != "TRUE" ]; then \
    echo -e "\e[0;31;49mInvalid value for build argument DISABLE_TRANSLATE, possible values: yes/true\e[;0m"; exit 1; \
    fi

# install translate/minify modules if need too
RUN if [ -z "$DISABLE_MINIFY" ] || [ -z "$DISABLE_TRANSLATE" ]; then cd meshcentral && npm install html-minifier jsdom minify-js; fi

# first extractall if need too
RUN if [ -z "$DISABLE_MINIFY" ] || [ -z "$DISABLE_TRANSLATE" ]; then cd meshcentral/translate && node translate.js extractall; fi

# minify files
RUN if [ -z "$DISABLE_MINIFY" ]; then cd meshcentral/translate && node translate.js minifyall; fi

# translate
RUN if [ -z "$DISABLE_TRANSLATE" ]; then cd meshcentral/translate && node translate.js translateall; fi

# cleanup
RUN rm -rf /opt/meshcentral/meshcentral/docker
RUN rm -rf /opt/meshcentral/meshcentral/node_modules

FROM --platform=$TARGETPLATFORM alpine:3.19

ARG UID=1000
ARG GID=1000
ARG INCLUDE_MONGODBTOOLS=""
ARG PREINSTALL_LIBS="false"

#Add non-root user, add installation directories and assign proper permissions
RUN adduser -D -S -u "${UID}" -G users node

RUN apk update \
    && apk add --no-cache --update tzdata nodejs npm bash python3 make gcc g++ \
    && rm -rf /var/cache/apk/*
RUN npm install -g npm@latest

RUN if ! [ -z "$INCLUDE_MONGODBTOOLS" ]; then apk add --no-cache mongodb-tools; fi

RUN mkdir -p /opt/meshcentral/meshcentral && chown -R $UID:$GID -R /opt/meshcentral
    
# copy files from builder-image
COPY --from=builder --chown=$UID:$GID /opt/meshcentral/meshcentral /opt/meshcentral/meshcentral

# environment variables
ENV NODE_ENV="production"
ENV CONFIG_FILE="config.json"

# environment variables for initial configuration file
ENV USE_MONGODB="false"
ENV FORCE_CREATE_CONFIG="false"
ENV MONGO_INITDB_ROOT_USERNAME="root"
ENV MONGO_INITDB_ROOT_PASSWORD="pass"
ENV MONGO_URL=""
ENV HOSTNAME="localhost"
ENV ALLOW_NEW_ACCOUNTS="true"
ENV ALLOWPLUGINS="false"
ENV LOCALSESSIONRECORDING="false"
ENV MINIFY="true"
ENV WEBRTC="false"
ENV IFRAME="false"
ENV SESSION_KEY=""
ENV REVERSE_PROXY="false"
ENV REVERSE_PROXY_TLS_PORT=""
ENV ARGS=""

# meshcentral installation
WORKDIR /opt/meshcentral

# Coppy needed files77
COPY --chown=$UID:$GID ./startup.sh ./startup.sh 
COPY --chown=$UID:$GID ./config.json.template ./config.json.template

# Coppy meshcentral
RUN chown -R $UID:$GID /opt/meshcentral

#Switch to user node
USER node

# NOTE: ALL MODULES MUST HAVE A VERSION NUMBER AND THE VERSION MUST MATCH THAT USED IN meshcentral.js mainStart()
RUN if ! [ -z "$INCLUDE_MONGODBTOOLS" ]; then cd meshcentral && npm install mongodb@4.13.0 saslprep@1.0.3; fi
RUN if ! [ -z "$PREINSTALL_LIBS" ] && [ "$PREINSTALL_LIBS" == "true" ]; then cd meshcentral && npm install ssh2@1.15.0 semver@7.5.4 nodemailer@6.9.8 image-size@1.0.2 wildleek@2.0.0 otplib@10.2.3 yubikeyotp@0.2.0; fi

# install dependencies from package.json and nedb
RUN cd meshcentral && npm install && npm install nedb

EXPOSE 80 443 4433

# volumes
#VOLUME /opt/meshcentral
VOLUME /opt/meshcentral/meshcentral-data
VOLUME /opt/meshcentral/meshcentral-files
VOLUME /opt/meshcentral/meshcentral-web
VOLUME /opt/meshcentral/meshcentral-backups

#Entry Point
CMD ["bash", "/opt/meshcentral/startup.sh"]