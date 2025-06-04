#!/bin/bash

# Create databases directory if it doesn't exist
mkdir -p databases

# Function to display the main menu
show_main_menu() {
    echo "Main Menu:"
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect To Database"
    echo "4. Drop Database"
    echo "5. Exit"
}

# Function to display the database menu
show_db_menu() {
    echo "Database Menu:"
    echo "1. Create Table"
    echo "2. List Tables"
    echo "3. Drop Table"
    echo "4. Insert into Table"
    echo "5. Select From Table"
    echo "6. Delete From Table"
    echo "7. Update Table"
    echo "8. Back to Main Menu"
}

# Main loop
while true; do
    show_main_menu
    read -p "Enter your choice: " choice
    case $choice in
        1)
            read -p "Enter database name: " dbname
            mkdir -p "databases/$dbname"
            echo "Database '$dbname' created."
            ;;
        2)
            echo "Databases:"
            ls -1 databases
            ;;
        3)
            read -p "Enter database name to connect: " dbname
            if [ -d "databases/$dbname" ]; then
                echo "Connected to database '$dbname'."
                # Enter database menu loop
                while true; do
                    show_db_menu
                    read -p "Enter your choice: " db_choice
                    case $db_choice in
                        1)
                            read -p "Enter table name: " tablename
                            read -p "Enter columns (comma-separated): " columns
                            echo "Enter one of the Available datatypes: int, string, float, date"
                            read -p "datatypes (comma-separated): " datatypes
                            read -p "Enter primary key column: " pk
                            echo "$columns" > "databases/$dbname/$tablename"
                            echo "$datatypes" >> "databases/$dbname/$tablename"
                            echo "$pk" >> "databases/$dbname/$tablename"
                            echo "Table '$tablename' created."
                            ;;
                        2)
                            echo "Tables in '$dbname':"
                            ls -1 "databases/$dbname"
                            ;;
                        3)
                            read -p "Enter table name to drop: " tablename
                            if [ -f "databases/$dbname/$tablename" ]; then
                                rm "databases/$dbname/$tablename"
                                echo "Table '$tablename' dropped."
                            else
                                echo "Table '$tablename' does not exist."
                            fi
                            ;;
                        4)
                            read -p "Enter table name: " tablename
                            if [ -f "databases/$dbname/$tablename" ]; then
                            # Read the primary key from line 3 of the table file
                            pk=$(sed -n '3p' "databases/$dbname/$tablename")
                            echo "This is your primary key: $pk — be sure you add it in the correct place."

                            read -p "Enter values (comma-separated): " values
                            echo "$values" >> "databases/$dbname/$tablename"
                            echo "Row inserted into '$tablename'."
                            else
                            echo "Table '$tablename' does not exist."
                            fi
                            ;;

                        5)
                            read -p "Enter table name: " tablename
                            if [ -f "databases/$dbname/$tablename" ]; then
                                echo "Contents of '$tablename':"
                                column -t -s, "databases/$dbname/$tablename"
                            else
                                echo "Table '$tablename' does not exist."
                            fi
                            ;;
                        6)
                            
                            read -p "Enter table name: " tablename
                            filepath="databases/$dbname/$tablename"
                            if [ -f "$filepath" ]; then
                                pk=$(sed -n '3p' "$filepath")
                                IFS=',' read -ra columns <<< "$(sed -n '1p' "$filepath")"
                                pk_index=-1
                                for i in "${!columns[@]}"; do
                                    if [[ "${columns[$i]}" == "$pk" ]]; then
                                        pk_index=$((i + 1))
                                        break
                                    fi
                                done
                                if [[ $pk_index -eq -1 ]]; then
                                    echo "Primary key column not found."
                                else
                                    read -p "Enter primary key value to delete: " pk_value
                                    awk -F, -v pk_index="$pk_index" -v pk_value="$pk_value" 'NR<=3 || $pk_index != pk_value' "$filepath" > tmp && mv tmp "$filepath"
                                    echo "Row with PK '$pk_value' deleted from '$tablename'."
                                fi
                            else
                                echo "Table '$tablename' does not exist."
                            fi
                            ;;

                        7)
                            read -p "Enter table name: " tablename
                            filepath="databases/$dbname/$tablename"
                            if [ -f "$filepath" ]; then
                                pk=$(sed -n '3p' "$filepath")
                                IFS=',' read -ra columns <<< "$(sed -n '1p' "$filepath")"
                                pk_index=-1
                                for i in "${!columns[@]}"; do
                                    if [[ "${columns[$i]}" == "$pk" ]]; then
                                        pk_index=$((i + 1))
                                        break
                                    fi
                                done
                                if [[ $pk_index -eq -1 ]]; then
                                    echo "Primary key column not found."
                                else
                                    read -p "Enter primary key value to update: " pk_value
                                    read -p "Enter new values (comma-separated): " new_values
                                    awk -F, -v pk_index="$pk_index" -v pk_value="$pk_value" -v new_values="$new_values" 'NR<=3 {print; next} $pk_index == pk_value {$0=new_values} {print}' "$filepath" > tmp && mv tmp "$filepath"
                                    echo "Row with PK '$pk_value' updated in '$tablename'."
                                fi
                            else
                                echo "Table '$tablename' does not exist."
                            fi
                            ;;
                        8)
                            break
                            ;;
                        *)
                            echo "Invalid choice."
                            ;;
                    esac
                done
            else
                echo "Database '$dbname' does not exist."
            fi
            ;;
        4)
            read -p "Enter database name to drop: " dbname
            if [ -d "databases/$dbname" ]; then
                rm -rf "databases/$dbname"
                echo "Database '$dbname' dropped."
            else
                echo "Database '$dbname' does not exist."
            fi
            ;;
        5)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
done 