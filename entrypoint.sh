#!/bin/bash

set -e

trap "Ok received Exit" HUP INT QUIT TERM

case "$1" in
    shell)
        exec /bin/bash --login
        ;;
    *)
        echo "Executing custom command"
        exec "$@"
        ;;
esac
