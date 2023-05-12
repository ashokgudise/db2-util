cd /diagnostic
find -type f -name "*.lmevents.bin" -exec rm -rv {} +
find -type f -name "*.SQLHA.events.bin" -exec rm -rv {} +
cd ~
