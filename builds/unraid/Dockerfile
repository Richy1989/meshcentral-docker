FROM node:lts-slim

ENV SESSION_KEY=""

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

ARG UID=1000
ARG GID=1000

#Add non-root user, add installation directories and assign proper permissions
#groupmod -g "${GID}" node && 
RUN usermod -u "${UID}" -g "${GID}" node \
    && mkdir -p /opt/meshcentral && chown node:node -R /opt/meshcentral

USER node

#meshcentral installation
WORKDIR /opt/meshcentral

RUN npm install meshcentral

ARG PREINSTALL_LIBS="false"

RUN if ! [ -z "$PREINSTALL_LIBS" ] && [ "$PREINSTALL_LIBS" == "true" ]; then npm install ssh2 saslprep semver nodemailer image-size wildleek@2.0.0 otplib@10.2.3 yubikeyotp; fi

COPY --chown=node:node config.json.template /opt/meshcentral/config.json.template
COPY --chown=node:node startup.sh startup.sh

#environment variables

EXPOSE 80 443

#volumes
VOLUME /opt/meshcentral/meshcentral-data
VOLUME /opt/meshcentral/meshcentral-files

CMD ["bash","/opt/meshcentral/startup.sh"]
