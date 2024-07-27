# Meshcentral-Docker for Unraid
![Docker Pulls](https://img.shields.io/docker/pulls/richy1989/meshcentral?style=flat-square)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/richy1989/meshcentral?style=flat-square)

## About
First of all my biggest thank you to ![Meshcentral Docker](https://github.com/Typhonragewind/meshcentral-docker) for the base code I used to create this version of Meshcentral optimized for Unraid.

While easier to setup and get up and running, you should still peer through the very informative official guides:

https://meshcentral.com/info/docs/MeshCentral2InstallGuide.pdf

https://meshcentral.com/info/docs/MeshCentral2UserGuide.pdf

## Disclaimer

This image is targeted for self-hosting in an Unraid Environment.
NOTE: That this image uses MongoDB. Hence an wokring MongoDB on Unraid is needed. 

## Installation

Download the App from the Unraid App store. Set all the environment variables.
This will create a basic config.json file in the DATA folder. For more specific configuration continue in this file, but make sure the FORCE_CREATE_CONFIG environmenrt variable is set to false!

NOTE: That this image uses the MongoDB. Hence a wokring MongoDB on Unraid is needed. 

## Tags

These tags are available in Dockerhub

## Final words

Be sure to check out MeshCentral's github repo. The project is amazing and the developers too!

## Changelog
2024-07-27 - Initial version
