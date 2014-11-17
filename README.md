macosx-vbox-headless
====================

A MAC OS X configuration helpful to start and stop a virtual box headless machine.

## Install

You should customize the following placeholders inside the file virtualbox.machine.plist:

- VM.VIRTUALBOX.NAME
- PATH_TO : the path where the vbox.sh script is stored.
- 12345678-1234-abcd-abcd-0123456789ab : This is the virtual machine unique id.
- WORKING_DIRECTORY_PATH : the path where the logs are stored. If you don't care about it, use: /tmp
- USERNAME : This is your username.

Then copy the file into /Library/LaunchDaemons/

    sudo cp virtualbox.machine.plist  /Library/LaunchDaemons/
