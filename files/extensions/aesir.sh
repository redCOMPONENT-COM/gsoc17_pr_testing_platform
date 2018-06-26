#!/usr/bin/env bash

##############################
# Test script to install aesir

REPOSITORY=$1
BRANCH=$2
INSTANCE_ID=$3
DOMAIN="domain"
INSTANCE_FOLDER=${INSTANCE_ID}.${DOMAIN}


####################################################################
# Pull latest aesir core and aesir

git clone --depth 1 -b develop --single-branch https://github.com/redCOMPONENT-COM/aesir-core.git aesir-core
git clone --depth 1 -b ${BRANCH} https://github.com/${REPOSITORY}.git aesir

cd aesir-core/build && cp gulp-config.json.dist gulp-config.json && gulp release && cd ../../
cd aesir && cp gulp-config.json.dist gulp-config.json && gulp release && cd ../


################################
# Install Joomlatools Composer and Joomlatools console
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php composer.phar require joomlatools/console

vendor/bin/joomla extension:installfile httpd/${INSTANCE_FOLDER}/htdocs aesir-core/tests/releases/aesir_core*.zip
vendor/bin/joomla extension:installfile httpd/${INSTANCE_FOLDER}/htdocs aesir/tests/releases/aesir*.zip
