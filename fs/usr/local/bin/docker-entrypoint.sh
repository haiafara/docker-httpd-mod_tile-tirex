#!/bin/sh
runuser -l _tirex -c 'tirex-master'
runuser -l _tirex -c 'tirex-backend-manager'
httpd-foreground
