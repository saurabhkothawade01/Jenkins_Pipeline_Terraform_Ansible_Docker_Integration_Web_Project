#!/bin/bash

# Replace the placeholder with the server's hostname
sed -i "s/{{SERVER_NAME}}/$(hostname)/" /usr/local/apache2/htdocs/index.html

# Start Apache HTTP Server
exec "$@"

