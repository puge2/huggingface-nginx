#!/bin/bash
mkdir ~/.screen && chmod 700 ~/.screen
export SCREENDIR=$HOME/.screen
supervisord -c /etc/supervisord.conf
chown -R www:www /var/run/nginx.pid
