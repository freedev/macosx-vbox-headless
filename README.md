macosx-vbox-headless
====================

Running/Stopping headless VMs during boot/shutdown under Mac OS X
AKA A MAC OS X configuration helpful to start and stop headless VMs.

## Install

You should customize the following placeholders inside the file virtualbox.machine.plist:

- `VM.VIRTUALBOX.NAME` : This required key uniquely identifies the job. If you don't have multiple vbox you can leave it as is.
- `PATH_TO` : the path where the vbox.sh script is stored.
- `12345678-1234-abcd-abcd-0123456789ab` : This is the virtual machine unique id.
- `WORKING_DIRECTORY_PATH` : the path where the logs are stored. If you don't care about it, use: /tmp
- `USERNAME` : This is your username.

Then copy the file `virtualbox.machine.plist` into `/Library/LaunchDaemons/`

    sudo cp virtualbox.machine.plist  /Library/LaunchDaemons/

When you want start the virtual machine type the following command:

    sudo launchctl load -w /Library/LaunchDaemons/virtualbox.machine.plist

If you want stop the VM (and the  you should type the following command:

    sudo launchctl unload -w /Library/LaunchDaemons/virtualbox.machine.plist

The VM will be started machine everytime MAC OS X boots.
Set into `virtualbox.machine.plist` the field `RunAtLoad` to `true` if you want that virtual machine starts automatically every time your mac os x boots

