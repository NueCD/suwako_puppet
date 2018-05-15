
# Suwako Puppet

Hai domo!

## Description

Puppet module that download and set up suwako-bot. Please have a look at [suwako-bot](https://github.com/NueCD/suwako-bot) before continuing.

## Setup

### Setup Requirements

Currently it only works on CentOS/RHEL.

### Beginning with suwako puppet

After the module is added, please have a look in the suwako_puppet/files/config.txt file. You will need to add your Discord API token here. You should only run this job on one single agent. Otherwise it will give you multiple responses for one message in chat.

## Usage

When the config file has been modified, just add "class { 'suwako_puppet::suwako': }" to the prefered node. Suwako will start automaticly as a service when the agent has finished its job setting it up. It does not use the enable => true, but only ensure => running. However the service will restart every 30 seconds if it would fail.

## Release Notes

Initial release. Probably the final release also.

Heil Suwako-sama!
