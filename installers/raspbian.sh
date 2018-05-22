UPDATE_URL="https://raw.githubusercontent.com/Edgity/pi-iot-sense/master/"
wget ${UPDATE_URL}/installers/common.sh -O /tmp/piiotsensecommon.sh
source /tmp/piiotsensecommon.sh && rm -f /tmp/piiotsensecommon.sh

function update_system_packages() {
    install_log "Updating sources"
    sudo apt-get update || install_error "Unable to update package list"
}

function install_dependencies() {
    echo "Installing required packages"
    sudo apt-get install avahi-daemon
    sudo insserv avahi-daemon
    wget -q https://raw.githubusercontent.com/Edgity/pi-iot-sense/master/etc/avahi/services/multiple.service -O /etc/avahi/services/multiple.service  
    sudo /etc/init.d/avahi-daemon restart
}

install_piiotsense
