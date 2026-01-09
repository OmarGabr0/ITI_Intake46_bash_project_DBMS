# Database Management System (Bash Shell Script)

## Overview

This project implements a **simple Database Management System (DBMS)** using **Bash shell scripting**. It simulates basic DBMS operations entirely through the **command-line interface**, using directories and text files to represent databases and tables. The goal is to demonstrate database concepts and file management using Bash, without relying on external database engines.

## Authors

* **Omar Gabr**
* **Medhat Osama**

**Track:** *Telecom Applications Development* — Information Technology Institute (ITI)

## Features

* **Database Operations**

  * Create a new database (as a directory)
  * List existing databases
  * Connect to a specific database
  * Delete a database

* **Table Operations**

  * Create tables with defined columns and data types
  * List existing tables
  * Drop/Delete a table

* **CRUD Operations**

  * Insert data into tables with type validation
  * Select data from tables
  * Update existing records
  * Delete records from tables

* **Simple Menu-Driven CLI**

  * All operations are accessed via intuitive command-line menus

## How It Works

* Each **database** is stored as a directory under the project folder.
* Each **table** is a text file (`.txt`) inside the corresponding database directory.
* Schema information is typically stored alongside table data or metadata files.
* Bash utilities (e.g., `read`, `awk`, `grep`, conditionals) handle data input, validation, and display.

## Getting Started

### Prerequisites

* A UNIX-like environment (Linux, macOS, WSL on Windows)
* Bash shell

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/OmarGabr0/ITI_Intake46_bash_project_DBMS.git
   ```

2. **Navigate to the Scripts directory**

   ```bash
   cd ITI_Intake46_bash_project_DBMS/Scripts
   ```

3. **Make scripts executable (if needed)**

   ```bash
   chmod +x *.sh
   ```

### Running the System

To launch the DBMS interface:

```bash
./main.sh
```

Follow on-screen prompts to interact with the system.

## Directory Structure

```
/Scripts
│── welcome.sh 
│── main.sh             
│── create_database.sh          
│── connect_to_database.sh           
│── drop_database.sh           
│── connect_to_database.sh         
│── create_table.sh       
│── insert_into_table.sh     
│── select_from_table.sh     
│── update_table.sh     
│── delete_from table.sh    
│── repeating_functions.sh
```

## Usage Example

1. Start the system.
2. Create a database (e.g., `StudentsDB`).
3. Connect to `StudentsDB`.
4. Create a table (e.g., `students`) with defined columns.
5. Insert records.
6. Use select, update, and delete as required.

## Project Learning Outcomes

* Practiced **Bash scripting** and command-line application design.
* Reinforced understanding of **database basics**, such as schema, tables, records, and CRUD operations.
* Demonstrated simple data validation and persistence using text-based storage.

## License

This project is provided for **educational purposes** as part of ITI coursework. Feel free to use and modify with proper attribution.



