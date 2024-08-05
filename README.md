# Meshcentral-Docker for Unraid
![Docker Pulls](https://img.shields.io/docker/pulls/richy1989/meshcentral?style=flat-square)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/richy1989/meshcentral?style=flat-square)

## About
First of all my biggest thank you to (https://github.com/Typhonragewind/meshcentral-docker) for the base code I used to create this version of Meshcentral optimized for Unraid.
The Idea with getting the sources directly is from the MeshCentral Docker build on the MeshCentral repo: (https://github.com/Ylianst/MeshCentral)

While easier to setup and get up and running, you should still peer through the very informative official guides:

https://meshcentral.com/info/docs/MeshCentral2InstallGuide.pdf

https://meshcentral.com/info/docs/MeshCentral2UserGuide.pdf

## Disclaimer
This image is targeted for self-hosting in an Unraid Environment.
**NOTE:** That this image uses MongoDB. The Database can be configured with a Database URL and User / Password. 
If you however choose to not use the MongoDB set the USE_MONGODB environment variabel to false, in this case MeshCentral will use an internal database. 

**NOTE:** All Sources are pulled directrly from the Meshcentral Repo. (See the GitHub Action File)
I only updated the dockerfile to be more accommodating for an Unraid build.

## Installation
Download the App from the Unraid App store. Set all the environment variables.
This will create a basic config.json file in the DATA folder. For more specific configuration continue in this file, but make sure the FORCE_CREATE_CONFIG environment variable is set to false!

## Building
You may build everything yourself, there is a build script, just update with your dockerhub name. 
Note: The right UID and PID for Unraid is set in the build process as build-args.

## Tags
These tags are available in Dockerhub

## Final words
Be sure to check out MeshCentral's github repo. The project is amazing and the developers too!

## Changelog
2024-08-05 - Get Sources directly from MeshCentral GitHub
2024-07-27 - Initial version
