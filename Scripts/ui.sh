# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

print_header() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "=========================================================="
    echo "                 Mini DBMS - Bash Edition                "
    echo "           Made by Omar Gabr & Medhat Osama               "
    echo "=========================================================="
    echo -e "${RESET}"
}

