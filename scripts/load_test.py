import psycopg2 as pg
from psycopg2 import sql
import os
import pandas as pd
from datetime import datetime
import argparse
import csv

# Function to capture the iteration_number
def iteration_number(root_path):
    run_file= os.path.join(root_path, "run.txt")
    with open(run_file, "r") as f:
        line= f.readline()
        # print(line[-1])
        it_num= int(line[0])
        run_num= int(line[-1])
        # print(it_num, run_num)
    return it_num, run_num

# Function to check if a database exists
def database_exists(conn, database_name):
    cursor = conn.cursor()
    cursor.execute("SELECT 1 FROM pg_database WHERE datname = %s", (database_name,))
    return cursor.fetchone() is not None

# Function to create tables
def create_table(create_table_sql_file, root_path, it_num):
    conn = pg.connect(**db_params)
    cur = conn.cursor()
    create_table_stats=[]
    print("creating relations in the database...")

    with open(create_table_sql_file, 'r') as file:
        query = file.read()

    try:
        start_time = datetime.now()
        cur.execute(query)
        conn.commit()
        end_time = datetime.now()
        execution_time = (end_time - start_time).total_seconds()
        create_table_stats.append(["Creating table with tpcds.sql", start_time, end_time, execution_time])
        print("saving the pandas dataframe to a csv...")
        df= pd.DataFrame(create_table_stats, columns=["Sql File", "Start Time", "End Time", "Execution Time"])
        df.to_csv(os.path.join(root_path, f'load_test_stats_sf_{scale_factor}_it_{it_num}.csv'), index=False)
        print(f" '{create_table_sql_file}' executed successfully in {execution_time} seconds.")

    except Exception as e:
        conn.rollback()
        print(f" '{create_table_sql_file}': Error executing query : {e}")

# Function to execute SQL queries and log execution times
def copy_into_db(sql_file, root_path, it_num):
    conn = pg.connect(**db_params)
    cur = conn.cursor()
    copy_db_time_list=[]
    print("populating the tables with data...")

    with open(sql_file, 'r') as file:
        query = file.read()

    try:
        start_time = datetime.now()
        cur.execute(query)
        conn.commit()
        end_time = datetime.now()
        execution_time = (end_time - start_time).total_seconds()
        copy_db_time_list.append(["copying data into the database", start_time, end_time, execution_time])
        print(f" '{sql_file}' executed successfully in {execution_time} seconds.")

    except Exception as e:
        conn.rollback()
        print(f" '{sql_file}': Error executing query : {e}")

    print("appending the csv file...")
    # df= pd.DataFrame(copy_db_time_list, columns=["Sql File", "Start Time", "End Time", "Execution Time"])
    # df.to_csv(os.path.join(root_path, f'copy_into_db_stats_sf{scale_factor}.csv'), index=False)
    with open(os.path.join(root_path, f'load_test_stats_sf_{scale_factor}_it_{it_num}.csv'), mode='a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(copy_db_time_list)
    print(f"load_test_stats for scale factor {scale_factor} saved successfully")

# parser to add arguments
parser = argparse.ArgumentParser()

# flags for obtaining and cleaning the data files
parser.add_argument("-rp", "--root_path", help="enter the root directory path")
parser.add_argument("-dp", "--data_path", help="enter the sql file path to copy all data files into tables")
parser.add_argument("-ct", "--create_table", help="this contains the sql file that creates tables i.e. tpcds.sql")
parser.add_argument("-sf", "--scale_factor", help="enter the path of all data files i.e. [1,3,5,10]")

args = parser.parse_args()

# defining the parameters
root_path= args.root_path
data_path= args.data_path
create_tables= args.create_table
scale_factor= args.scale_factor

# setting the iteration number for the test
current_it, current_run= iteration_number(root_path= root_path)

# print start
print("---------------------------------------------")
print(f"ITERATION {current_it}: STARTING LOAD TEST")
print("---------------------------------------------")

# defining the new database name
new_database_name=f"tpcds_sf_{scale_factor}"

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

if not database_exists(conn, new_database_name):
    # Set autocommit mode to create the database outside of a transaction
    conn.set_isolation_level(0)

    # Create the new database
    create_db_query = sql.SQL("CREATE DATABASE {}").format(sql.Identifier(new_database_name))
    cur = conn.cursor()
    cur.execute(create_db_query)
    print(f"database tpcds_sf_{scale_factor} created successfully")
    
    # Reset the isolation level to its default
    conn.set_isolation_level(1)


else:
    # The database already exists, do nothing
    print(f"Database '{new_database_name}' already exists, no action required.")

# printing the version 
cur.execute("SELECT version();")
print("PostgreSQL version:")
print(cur.fetchone())

# changunng the db params to connect to the newly created db
db_params = {
    "host": "localhost",
    "user": "postgres",
    "database": f"tpcds_sf_{scale_factor}",
    "password": "1*@#Saymyname"
}

# executing the queries to copy the data from the files ot the database tables
t_start= datetime.now()
print("connecting to the newly created DB...")
create_table(create_tables, root_path= root_path, it_num= current_it)
copy_into_db(data_path, root_path= root_path, it_num=current_it)
t_end= datetime.now()
t_exec= (t_end - t_start).total_seconds()

# writing the data to a txt file
with open(os.path.join(root_path, f"load_test_stats_sf_{scale_factor}.txt"), "a") as f:
    f.write(f"Iteration {current_it}: Total time taken for running load test on scale factor {scale_factor} iteration {current_it}= {t_exec} seconds\n")

print(f"Loading the database takes {t_exec} seconds")

# Close the cursor and the connection when you're done
cur.close()
conn.close()