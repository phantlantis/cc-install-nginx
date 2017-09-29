# cc-install-nginx
This script can be used to install nginx on a debian based system.

It has been successfully tested on Ubuntu 16.04, 14.04, and Debian 9.1.

INSTRUCTIONS:
1. Clone the repository to the server (you must have git installed to do this).

    You can accomplish this by updating your package caches by running:
    "sudo apt-get update"

    And then running
    "sudo apt-get install -y git"

    And then cloning this repository by typing "git clone https://github.com/phantlantis/cc-install-nginx.git"

2. Grant executable permissions to the installation script.

    You can accomplish this by navigating to the cc-install-nginx directory:

    And then running
    "chmod +x ./install-nginx.sh"

3. Run the script

    "./install-nginx.sh"

    Be sure to include the "./" before the script name.
