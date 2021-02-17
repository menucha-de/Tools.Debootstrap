#!/bin/bash

# nc -ll -p 80 -e /usr/bin/httpd.sh

ROOT=/var/www
CONTENT_TYPE="text/plain; charset=utf-8"

reply() {
  echo HTTP/1.1 $1
  echo Date: $(date -R)
  echo Connection: close
  if [ -n "$2" ]; then
    echo Content-type: $CONTENT_TYPE
    echo Content-Length: $(stat -c "%s" "$2")
    echo
    cat "$2"
  else
    echo
  fi
  exit
}

while read line; do
  line=${line%$'\r'}
  case ${line%% *} in
    GET)
      name=${line:4}
      case ${name%%[ ?]*} in
        /ABOUT)
          CONTENT_TYPE="application/json"
          reply "200 OK" /META/configuration.json
          ;;
        /|/API|/any)
          CONTENT_TYPE="application/xml"
          reply "200 OK" $ROOT/api.xml
          ;;
        /default.xsl)
          CONTENT_TYPE="application/xml"
          reply "200 OK" $ROOT/default.xsl
          ;;
       /style.css)
          CONTENT_TYPE="text/css"
          reply "200 OK" $ROOT/style.css
          ;;
        *)
          reply "400 Not Found"
          ;;
      esac
      ;;
    *)
      reply "405 Method Not Allowed"
      ;;
  esac
done
