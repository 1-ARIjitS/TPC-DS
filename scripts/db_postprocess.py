import psycopg2 as pg
from psycopg2 import sql
import os
import pandas as pd
from datetime import datetime
import argparse

# Function to capture the iteration_number
def iteration_number(root_path):
    run_file= os.path.join(root_path, "run.txt")
    with open(run_file, "r") as f:
        line= f.readline()
        it_num= int(line[0])
        run_num= int(line[-1])
    return it_num, run_num

# Function to update the iteration number
def update_it_num(root_path, current_it_num, current_run):
    run_file= os.path.join(root_path, "run.txt")
    with open(run_file, "w") as f:
        updated_it_num= str(current_it_num+1)
        updated_run_num= str(1)
        f.write(f"{updated_it_num}, {updated_run_num}")  
        
# Function to check if a database exists
def database_exists(conn, database_name):
    cursor = conn.cursor()
    cursor.execute("SELECT 1 FROM pg_database WHERE datname = %s", (database_name,))
    return cursor.fetchone() is not None

# parser to add arguments
parser = argparse.ArgumentParser()

# flags for obtaining and cleaning the data files
parser.add_argument("-rp", "--root_path", help="enter the root directory path")
parser.add_argument("-sf", "--scale_factor", help="enter the path of all data files i.e. [1,3,5,10]")

args = parser.parse_args()

root_path= args.root_path
scale_factor= args.scale_factor

# setting the iteration number for the test
current_it, current_run= iteration_number(root_path= root_path)

# print start
print("-----------------------------------------------------")
print(f"ITERATION {current_it}: STARTING DB POSTPROCESSING")
print("-----------------------------------------------------")

# defining the database name
database_name=f"tpcds_sf_{scale_factor}"

# Defining the connection parameters
db_params = {
    "host": "localhost",
    "user": "postgres",
    # "database": f"tpcds_sf{scale_factor}",
    "password": "1*@#Saymyname"
}

# Establish a connection to the PostgreSQL database
try:
    conn = pg.connect(**db_params)
    print("Connected to the database")
except Exception as e:
    print(f"Error: {e}")

# printing the version 
cur= conn.cursor()
cur.execute("SELECT version();")
print("PostgreSQL version:")
print(cur.fetchone())

if database_exists(conn, database_name):
    # Set autocommit mode to create the database outside of a transaction
    conn.set_isolation_level(0)

    # Create the new database
    drop_db_query = sql.SQL("DROP DATABASE {}").format(sql.Identifier(database_name))
    cur = conn.cursor()
    t_start= datetime.now()
    cur.execute(drop_db_query)
    t_end= datetime.now()
    t_exec= (t_end-t_start).total_seconds()
    with open(os.path.join(root_path, f"db_postprocessing_stats_sf_{scale_factor}.txt"), "a") as f:
        f.write(f"Iteration {current_it}: total time taken for droppin the database= {t_exec} seconds\n")
    print(f"database tpcds_sf_{scale_factor} dropped in {t_exec} seconds")
    
    # Reset the isolation level to its default
    conn.set_isolation_level(1)

else:
    # The database already exists, do nothing
    print(f"Database '{database_name}' does not exist")

# updating the iteration number as this is the end of one cycle of the tpc-ds benchmarking
update_it_num(root_path= root_path, current_it_num= current_it, current_run= current_run)

# Close the cursor and the connection when you're done
cur.close()
conn.close()