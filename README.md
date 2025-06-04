# Bash Shell Script Database Management System (DBMS)

This project implements a simple CLI-based DBMS using Bash scripting. It allows users to create, list, connect to, and drop databases, as well as perform table operations such as creating, listing, dropping, inserting, selecting, deleting, and updating tables.

## Features

- **Main Menu:**
  - Create Database
  - List Databases
  - Connect To Database
  - Drop Database

- **Database Menu:**
  - Create Table
  - List Tables
  - Drop Table
  - Insert into Table
  - Select From Table
  - Delete From Table
  - Update Table

## How to Run

1. Ensure you have Bash installed on your system.
2. Clone or download this repository.
3. Navigate to the project directory.
4. Run the script:
   ```bash
   ./dbms.sh
   ```

## Project Structure

- `dbms.sh`: Main script to run the DBMS.
- `databases/`: Directory where all databases (directories) are stored.

## Notes

- Each database is stored as a directory under `databases/`.
- Each table is a file inside its database directory.
- The first line of a table file contains column names, the second line contains datatypes, and the third line specifies the primary key. 