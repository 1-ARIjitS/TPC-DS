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
        updated_it_num= str(current_it_num)
        updated_run_num= str(current_run+1)
        f.write(f"{updated_it_num}, {updated_run_num}") 

# Function to execute SQL queries and log execution times
def execute_maintenance_queries(root_path, query_files_path, scale_factor, it_num, run_num):
    conn = pg.connect(**db_params)
    cur = conn.cursor()
    query_files_list=[]
    # method_folder_list=[]
    m_query_exec_time_list=[]

    for folders in os.listdir(query_files_path):
        method_folder= os.path.join(query_files_path, folders)
        for files in os.listdir(method_folder):
            query_file= os.path.join(method_folder, files)
            query_files_list.append(query_file)
    
    # if run_num==2:
    #     query_files_list.pop(0)
    #     # query_files_list.pop(1)
    #     query_files_list.pop(1)

    print(query_files_list)

    for sql_file in query_files_list:
        with open(os.path.join(query_files_path, sql_file), 'r') as file:
            query = file.read()

            try:
                start_time = datetime.now()
                cur.execute(query)
                conn.commit()
                end_time = datetime.now()
                execution_time = (end_time - start_time).total_seconds()
                m_query_exec_time_list.append([sql_file, start_time, end_time, execution_time])
                print(f" '{sql_file}' executed successfully in {execution_time} seconds.")

            except Exception as e:
                conn.rollback()
                print(f" '{sql_file}': Error executing query : {e}")

            print("saving the pandas dataframe to a csv...")
            df= pd.DataFrame(m_query_exec_time_list, columns=["Sql File", "Start Time", "End Time", "Execution Time"])
            df.to_csv(os.path.join(root_path, f'maintenance_test_stats_sf_{scale_factor}_it_{it_num}_run_{run_num}.csv'), index=False)
            print(f"maintenance stats for scale factor {scale_factor} saved successfully")

# parser to add arguments
parser = argparse.ArgumentParser()

# flags for obtaining and cleaning the data files
parser.add_argument("-rp", "--root_path", help="enter the root directory path")
parser.add_argument("-mp", "--maintenance_query_path", help="enter the path ehich has all the mainteneance sql files")
# parser.add_argument("-qp", "--query_path", help="this path contains the maintenance query files")
parser.add_argument("-sf", "--scale_factor", help="enter the path of all data files i.e. [1,3,5,10]")

args = parser.parse_args()

# defining the parameters
root_path= args.root_path
maintenance_query_path= args.maintenance_query_path
# query_path= args.query_path
scale_factor= args.scale_factor

# setting the iteration number for the test
current_it, current_run= iteration_number(root_path= root_path)

# print start
print("-----------------------------------------------------------------")
print(f"ITERATION {current_it}: STARTING MAINTENANCE TEST {current_run}")
print("-----------------------------------------------------------------")

# Defining the connection parameters
db_params = {
    "host": "localhost",
    "user": "postgres",
    "database": f"tpcds_sf_{scale_factor}",
    "password": "1*@#Saymyname"
}

# Establish a connection to the PostgreSQL database
try:
    conn = pg.connect(**db_params)
    print("Connected to the database")
except Exception as e:
    print(f"Error: {e}")

# printing the version 
cur = conn.cursor()
cur.execute("SELECT version();")
print("PostgreSQL version:")
print(cur.fetchone())

# executing the queries to copy the data from the files ot the database tables
t_start= datetime.now()
# starting the maintenance tests
execute_maintenance_queries(root_path= root_path, query_files_path= maintenance_query_path, scale_factor= scale_factor, it_num= current_it, run_num= current_run)
t_end= datetime.now()
t_exec= (t_end - t_start).total_seconds()

with open(os.path.join(root_path, f"maintenance_test_stats_sf_{scale_factor}.txt"), "a") as f:
    f.write(f"Iteration {current_it} run {current_run}: total time taken for running maintenace test on scale factor {scale_factor} = {t_exec} seconds\n")

print(f"maintenance test takes {t_exec} seconds")

# updating the run number for maintenance test 1 and maintenance test 2
update_it_num(root_path, current_it, current_run)

# Close the cursor and the connection when you're done
cur.close()
conn.close()