#!/bin/bash

chmod a+w /etc/sudoers
sed -i '$a Defaults:$1 !requiretty' /etc/sudoers
chmod a-w /etc/sudoers
