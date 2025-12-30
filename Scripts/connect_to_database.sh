#!/usr/bin/bash
declare -a buffer
source repeating_functions.sh

if [ $# -eq 0 ]; then
    while true; do
        DB_Name=$(zenity --entry --title="Connect to Database" --text="Enter the database name:")
        is_empty $DB_Name
        if [ $? -eq 0 ]; then
            DB_Path="../Databases/$DB_Name"
            break
        else
            zenity --error --text="Empty input is not allowed!"
        fi
    done
elif [ $# -eq 1 ]; then
    DB_Name="$1"
    DB_Path="../Databases/$DB_Name"
fi

while true; do
    check_if_exists d $DB_Path
    if [ $? -eq 1 ]; then
        while true; do
            choice=$(zenity --list --title="Database: $DB_Name" \
                --column="Option" \
                "Create Table" \
                "List Tables" \
                "Drop Table" \
                "Insert into Table" \
                "Select from Table" \
                "Delete From Table" \
                "Update Table" \
                "Exit")

            case $choice in
                "Create Table")
                    table_name=$(zenity --entry --title="Create Table" --text="Enter table name:")
                    if [ -n "$table_name" ]; then
                        ./create_table.sh "$DB_Name" "$table_name"
                        zenity --info --text="Table '$table_name' created successfully!"
                    fi
                    ;;
                "List Tables")
                    tables=$(ls $DB_Path | tr '\n' ' ')
                    zenity --info --title="Tables in $DB_Name" --text="$tables"
                    ;;
                "Drop Table")
                    table_name=$(zenity --entry --title="Drop Table" --text="Enter table name to drop:")
                    if [ -n "$table_name" ]; then
                        ./drop_table.sh "$DB_Name" "$table_name"
                        zenity --info --text="Table '$table_name' dropped!"
                    fi
                    ;;
                "Insert into Table")
                    ./insert_into_table.sh "$DB_Name"
                    ;;
                "Select from Table")
                    ./enhanced_select_from_table.sh "$DB_Name"
                    ;;
                "Delete From Table")
                    ./delete_from_table.sh "$DB_Name"
                    ;;
                "Update Table")
                    ./update_table.sh "$DB_Name"
                    ;;
                "Exit")
                    exit 0
                    ;;
                *)
                    zenity --error --text="Invalid option!"
                    ;;
            esac
        done
    else
        retry=$(zenity --list --title="Database Not Found" \
            --column="Option" "Enter another name" "Exit")
        case $retry in
            "Enter another name")
                ;;
            "Exit")
                exit 0
                ;;
        esac
    fi
done
