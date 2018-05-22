piiotsense_dir="/etc/piiotsense"
piiotsense_user="piiotsense"
version=`sed 's/\..*//' /etc/debian_version`

# Determine version 

if [ $version -eq 9 ]; then 
    version_msg="Raspian 9.0 (Stretch)" 
elif [ $version -eq 8 ]; then 
    version_msg="Raspian 8.0 (Jessie)" 
else 
    version_msg="Raspian earlier than 8.0 (Wheezy)"
fi 

# Outputs a RaspAP Install log line
function install_log() {
    echo -e "\033[1;32mPiIotSense Install: $*\033[m"
}

# Outputs a RaspAP Install Error log line and exits with status code 1
function install_error() {
    echo -e "\033[1;37;41mPiIotSense Install Error: $*\033[m"
    exit 1
}

# Outputs a welcome message
function display_welcome() {
    echo -e "The Quick Installer for Pi IOT Sense will guide you through a few easy steps\n\n"
}

### NOTE: all the below functions are overloadable for system-specific installs
### NOTE: some of the below functions MUST be overloaded due to system-specific installs

function config_installation() {
    install_log "Configure installation"
    echo "Detected ${version_msg}" 
    echo "Install directory: ${piiotsense_dir}"
    echo -n "Complete installation with these values? [y/N]: "
    read answer
    if [[ $answer != "y" ]]; then
        echo "Installation aborted."
        exit 0
    fi
}

# Runs a system software update to make sure we're using all fresh packages
function update_system_packages() {
    # OVERLOAD THIS
    install_error "No function definition for update_system_packages"
}

# Installs additional dependencies using system package manager
function install_dependencies() {
    # OVERLOAD THIS
    install_error "No function definition for install_dependencies"
}

# Verifies existence and permissions of piiotsense directory
function create_piiotsense_directories() {
    install_log "Creating PiIOTSense directories"
    if [ -d "$piiotsense_dir" ]; then
        sudo mv $piiotsense_dir "$piiotsense_dir.`date +%F-%R`" || install_error "Unable to move old '$piiotsense_dir' out of the way"
    fi
    sudo mkdir -p "$piiotsense_dir" || install_error "Unable to create directory '$piiotsense_dir'"

    # Create a directory for existing file backups.
    sudo mkdir -p "$piiotsense_dir/backups"

    #sudo chown -R $piiotsense_user:$piiotsense_user "$piiotsense_dir" || install_error "Unable to change file ownership for '$piiotsense_dir'"
}


# Fetches latest files from github to webroot
function download_latest_files() {
    if [ -d "$piiotsense_dir" ]; then
        sudo mv $piiotsense_dir "$piiotsense_dir.`date +%F-%R`" || install_error "Unable to remove old Pi IOT Sense directory"
    fi

    install_log "Cloning latest files from github"
    git clone --depth 1 https://github.com/Edgity/pi-iot-sense /tmp/piiotsense || install_error "Unable to download files from github"
    sudo mv /tmp/piiotsense $piiotsense_dir || install_error "Unable to move pi iot sense to piiotsense"
}

# Sets files ownership in web root directory
function change_file_ownership() {
    if [ ! -d "$piiotsense_dir" ]; then
        install_error "Pi IOT Sense directory doesn't exist"
    fi

    install_log "Changing file ownership in Pi IOT Sense directory"
    sudo chown -R $piiotsense_user:$piiotsense_user "$piiotsense_dir" || install_error "Unable to change file ownership for '$piiotsense_dir'"
}

# Check for existing /etc/network/interfaces and /etc/hostapd/hostapd.conf files
function check_for_old_configs() {
    if [ -f /etc/rc.local ]; then
        sudo cp /etc/rc.local "$piiotsense_dir/backups/rc.local.`date +%F-%R`"
        sudo ln -sf "$piiotsense_dir/backups/rc.local.`date +%F-%R`" "$piiotsense_dir/backups/rc.local"
    fi
}


# Set up default configuration
function default_configuration() {
    install_log "Setting up avahi"
    sudo apt-get install avahi-daemon
    sudo insserv avahi-daemon
    if [ -f /etc/avahi/services/multiple.service ]; then
        sudo mv /etc/avahi/services/multiple.service /tmp/default_service.old || install_error "Unable to remove old /etc/default/hostapd file"
    fi
    sudo /etc/init.d/avahi-daemon restart
    
    install_log "Setting up RaspAp"
    wget -q https://git.io/vhvB7 -O /tmp/raspap && bash /tmp/raspap
}



function install_complete() {
    install_log "Installation completed!"

    echo -n "The system needs to be rebooted as a final step. Reboot now? [y/N]: "
    read answer
    if [[ $answer != "y" ]]; then
        echo "Installation aborted."
        exit 0
    fi
    sudo shutdown -r now || install_error "Unable to execute shutdown"
}

function install_piiotsense() {
    display_welcome
    config_installation
    update_system_packages
    install_dependencies
    create_piiotsense_directories
    check_for_old_configs
    download_latest_files
    default_configuration
    install_complete
}
