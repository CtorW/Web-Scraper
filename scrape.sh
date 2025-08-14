#!/bin/bash


# ft. pup
#   ██████  ▄████▄   ██▀███   ▄▄▄       ██▓███  ▓█████ 
# ▒██    ▒ ▒██▀ ▀█  ▓██ ▒ ██▒▒████▄    ▓██░  ██▒▓█   ▀ 
# ░ ▓██▄   ▒▓█    ▄ ▓██ ░▄█ ▒▒██  ▀█▄  ▓██░ ██▓▒▒███   
#   ▒   ██▒▒▓▓▄ ▄██▒▒██▀▀█▄  ░██▄▄▄▄██ ▒██▄█▓▒ ▒▒▓█  ▄ 
# ▒██████▒▒▒ ▓███▀ ░░██▓ ▒██▒ ▓█   ▓██▒▒██▒ ░  ░░▒████▒
# ▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▓▒░ ░  ░░░ ▒░ ░
# ░ ░▒  ░ ░  ░  ▒     ░▒ ░ ▒░  ▒   ▒▒ ░░▒ ░      ░ ░  ░
# ░  ░  ░  ░          ░░   ░   ░   ▒   ░░          ░   
#       ░  ░ ░         ░           ░  ░            ░  ░
#          ░                                           

if tput setaf 1 >/dev/null 2>&1; then
    Color_Off="$(tput sgr0)"
    Black="$(tput setaf 0)"
    Red="$(tput setaf 1)"
    Green="$(tput setaf 2)"
    Yellow="$(tput setaf 3)"
    Blue="$(tput setaf 4)"
    Purple="$(tput setaf 5)"
    Cyan="$(tput setaf 6)"
    White="$(tput setaf 7)"

    BBlack="$(tput bold; tput setaf 0)"
    BRed="$(tput bold; tput setaf 1)"
    BGreen="$(tput bold; tput setaf 2)"
    BYellow="$(tput bold; tput setaf 3)"
    BBlue="$(tput bold; tput setaf 4)"
    BPurple="$(tput bold; tput setaf 5)"
    BCyan="$(tput bold; tput setaf 6)"
    BWhite="$(tput bold; tput setaf 7)"

    BIBlack="$(tput bold; tput setaf 8)"
    BIRed="$(tput bold; tput setaf 9)"
    BIGreen="$(tput bold; tput setaf 10)"
    BIYellow="$(tput bold; tput setaf 11)"
    BIBlue="$(tput bold; tput setaf 12)"
    BIPurple="$(tput bold; tput setaf 13)"
    BICyan="$(tput bold; tput setaf 14)"
    BIWhite="$(tput bold; tput setaf 15)"
else
    Color_Off="\033[0m"
    Black="\033[0;30m"
    Red="\033[0;31m"
    Green="\033[0;32m"
    Yellow="\033[0;33m"
    Blue="\033[0;34m"
    Purple="\033[0;35m"
    Cyan="\033[0;36m"
    White="\033[0;37m"

    BBlack="\033[1;30m"
    BRed="\033[1;31m"
    BGreen="\033[1;32m"
    BYellow="\033[1;33m"
    BBlue="\033[1;34m"
    BPurple="\033[1;35m"
    BCyan="\033[1;36m"
    BWhite="\033[1;37m"
    
    BIBlack="\033[1;90m"
    BIRed="\033[1;91m"
    BIGreen="\033[1;92m"
    BIYellow="\033[1;93m"
    BIBlue="\033[1;94m"
    BIPurple="\033[1;95m"
    BICyan="\033[1;96m"
    BIWhite="\033[1;97m"
fi

select_option() {
    local options=("$@")
    local num_options=${#options[@]}
    local selected=0
    
    local BCyan_BG_Black="$(tput setab 6; tput setaf 0)"

    echo -e "${BIWhite}Please select an option using the arrow keys and Enter:${Color_Off}"

    for i in "${!options[@]}"; do
        if [ "$i" -eq $selected ]; then
            echo -e "${BCyan_BG_Black} > ${options[$i]} ${Color_Off}"
        else
            echo -e "${BYellow}   ${options[$i]} ${Color_Off}"
        fi
    done

    while true; do
        tput cuu "${num_options}"
        
        for i in "${!options[@]}"; do
            tput el
            if [ "$i" -eq $selected ]; then
                echo -e "${BCyan_BG_Black} > ${options[$i]} ${Color_Off}"
            else
                echo -e "${BYellow}   ${options[$i]} ${Color_Off}"
            fi
        done

        read -rsn1 key
        case "$key" in
            $'\x1b') 
                read -rsn2 -t 0.1 key
                case "$key" in
                    '[A') # Up arrow
                        ((selected--))
                        if [ $selected -lt 0 ]; then
                            selected=$((num_options - 1))
                        fi
                        ;;
                    '[B') # Down arrow
                        ((selected++))
                        if [ $selected -ge $num_options ]; then
                            selected=0
                        fi
                        ;;
                esac
                ;;
            '') # Enter key
                echo
                break
                ;;
        esac
    done

    return $selected
}

check_dependencies() {
    echo -e "${BIBlue}Checking for required dependencies...${Color_Off}"
    local deps=("curl" "pup")
    local missing_deps=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${BIYellow}The following dependencies are missing: ${missing_deps[*]}${Color_Off}"
        echo -e "${BIYellow}Attempting to install them...${Color_Off}"
        
        if command -v apt-get &>/dev/null; then
            sudo apt-get update && sudo apt-get install -y "${missing_deps[@]}"
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y "${missing_deps[@]}"
        elif command -v yum &>/dev/null; then
            sudo yum install -y "${missing_deps[@]}"
        elif command -v pacman &>/dev/null; then
            sudo pacman -Sy --noconfirm "${missing_deps[@]}"
        else
            echo -e "${BRed}Error: Cannot find a supported package manager. Please install ${missing_deps[*]} manually.${Color_Off}"
            exit 1
        fi

        if [ $? -eq 0 ]; then
            echo -e "${BGreen}Dependencies installed successfully.${Color_Off}"
        else
            echo -e "${BRed}Error: Failed to install dependencies. Please install them manually.${Color_Off}"
            exit 1
        fi
    else
        echo -e "${BGreen}All dependencies are met.${Color_Off}"
    fi
}

scrape_website() {
    clear
    echo -e "${BWhite}Web Scraper${Color_Off}"
    echo "-----------"
    read -p "Enter the URL to scrape: " url
    read -p "Enter the CSS selector (e.g., h1.title): " selector

    if [[ -z "$url" || -z "$selector" ]]; then
        echo -e "${BYellow}URL and selector cannot be empty.${Color_Off}"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi

    echo -e "${BIBlue}Fetching and scraping data from ${url}...${Color_Off}"
    echo "--------------------------------------------------"
    
    local content=$(curl --silent --fail-with-body "$url" | pup "$selector" text)

    if [ -z "$content" ]; then
        echo -e "${BRed}No content found for the given selector.${Color_Off}"
    else
        echo -e "${BGreen}Scraped Content:${Color_Off}"
        echo -e "${content}"
    fi

    echo "--------------------------------------------------"
    read -n 1 -s -r -p "Press any key to continue..."
}

main() {
    check_dependencies
    
    while true; do
        clear
        local options=("Scrape a Website" "Exit")
        select_option "${options[@]}"
        local choice=$?

        case "$choice" in
            0) scrape_website ;;
            1) echo -e "${BIGreen}Exiting script. Goodbye!${Color_Off}"; exit 0 ;;
            *) echo -e "${BRed}Invalid choice.${Color_Off}"; read -n 1 -s -r -p "Press any key to continue..." ;;
        esac
    done
}

main
