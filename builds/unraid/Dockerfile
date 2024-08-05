FROM node:lts-slim

#Clear Session key Environment variable
ENV SESSION_KEY=""

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

ARG UID=1000
ARG GID=1000

#Add installation directories and assign proper permissions
#groupmod -g "${GID}" node && 
RUN usermod -u "${UID}" -g "${GID}" node \
    && mkdir -p /opt/meshcentral && chown node:node -R /opt/meshcentral

#Switch to user node
USER node

#meshcentral installation
WORKDIR /opt/meshcentral

#Install Meshcentral
RUN npm install meshcentral

#Only needed if we need to preinstall libs
ARG PREINSTALL_LIBS="false"
RUN if ! [ -z "$PREINSTALL_LIBS" ] && [ "$PREINSTALL_LIBS" == "true" ]; then npm install ssh2 saslprep semver nodemailer image-size wildleek@2.0.0 otplib@10.2.3 yubikeyotp; fi

#Copy files
COPY --chown=node:node config.json.template /opt/meshcentral/config.json.template
COPY --chown=node:node startup.sh startup.sh

EXPOSE 80 443 4433

#volumes
VOLUME /opt/meshcentral/meshcentral-data
VOLUME /opt/meshcentral/meshcentral-files

#Entry Point
CMD ["bash","/opt/meshcentral/startup.sh"]
