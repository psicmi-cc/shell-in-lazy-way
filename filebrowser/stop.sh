kill -9 `ps -ef | grep filebrowser | awk '/\/usr\/local\/bin\/filebrowser/ {print $2}'`
