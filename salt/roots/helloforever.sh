#!/usr/bin/env bash
/usr/bin/nodejs /usr/local/lib/node_modules/forever/bin/forever --uid "helloworld" start /srv/salt/helloworld.js 
return 0
