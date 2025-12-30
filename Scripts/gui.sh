#!/usr/bin/bash
# gui.sh - GUI wrapper for your database project

while true; do
    # Main menu
    choice=$(zenity --list --title="Database Menu" \
        --column="Option" \
        "Create Database" \
        "List Databases" \
        "Connect To Database" \
        "Drop Database" \
        "Exit")

    case $choice in
        "Create Database")
            db_name=$(zenity --entry --title="Create Database" --text="Enter database name:")
            if [ -n "$db_name" ]; then
                ./create_database.sh "$db_name"
                zenity --info --text="Database '$db_name' created successfully!"
            fi
            ;;
        "List Databases")
            dbs=$(ls ../Databases | tr '\n' ' ')
            zenity --info --title="Databases" --text="$dbs"
            ;;
        "Connect To Database")
            db_name=$(zenity --entry --title="Connect To Database" --text="Enter database name:")
            if [ -n "$db_name" ]; then
                ./connect_to_database.sh "$db_name"
            fi
            ;;
        "Drop Database")
            db_name=$(zenity --entry --title="Drop Database" --text="Enter database name to drop:")
            if [ -n "$db_name" ]; then
                ./drop_database.sh "$db_name"
                zenity --info --text="Database '$db_name' dropped!"
            fi
            ;;
        "Exit")
            zenity --info --text="Thanks for your time :)"
            exit 0
            ;;
        *)
            zenity --error --text="Invalid option!"
            ;;
    esac
done
