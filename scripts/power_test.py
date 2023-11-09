import psycopg2 as pg
import os
import shutil
import pandas as pd
import numpy as np
from datetime import datetime
import csv
import re
from tqdm import tqdm
import argparse

# Function to capture the iteration_number
def iteration_number(root_path):
    run_file= os.path.join(root_path, "run.txt")
    with open(run_file, "r") as f:
        line= f.readline()
        it_num= int(line[0])
        run_num= int(line[-1])
    return it_num, run_num

# Function to extract the query number
def extract_query_num(filename):
    res= re.split("[ _ | . ]", filename)
    num= int(res[1])
    return num

# Function to execute SQL queries and log execution times
def execute_queries(root_path, sql_folder, scale_factor, it_num):
    conn = pg.connect(**db_params)
    cur = conn.cursor()
    wrong_query_list=[]
    sql_file_list=[]
    stats_list=[]
        
    for filename in os.listdir(sql_folder):
        if filename.endswith(".sql"):
            sql_file_list.append(filename)
    
    sorted_sql_file_list= sorted(sql_file_list, key=extract_query_num)
    sql_file_list= sorted_sql_file_list
    
    with tqdm(total= len(sql_file_list)) as pbar:
        for filename in sql_file_list:
            query_file = os.path.join(sql_folder, filename)

            with open(query_file, 'r') as file:
                query = file.read()

            try:
                start_time = datetime.now()
                cur.execute(query)
                conn.commit()
                end_time = datetime.now()
                execution_time = (end_time - start_time).total_seconds()
                stats_list.append([filename, start_time, end_time, execution_time])
                pbar.set_postfix(file=filename, start=start_time, end=end_time, time=execution_time)
                pbar.update(1)
                print(f" '{filename}' executed successfully in {execution_time} seconds.")

            except Exception as e:
                conn.rollback()
                wrong_query_list.append(filename)
#                 pbar.set_postfix(file=filename, error=str(e))
#                 pbar.update(1)
                print(f" '{filename}': Error executing query : {e}")
    
    # printing the list of queries that are wrong
    if len(wrong_query_list)!=0:
        print(wrong_query_list)
    else:
        print("No wrong query found during processing")
    
    # save the stats to a csv file 
    print("saving the pandas dataframe to a csv...")
    df= pd.DataFrame(stats_list, columns=["Query File", "Start Time", "End Time", "Execution Time"])
    df.to_csv(os.path.join(root_path, f'power_test_stats_sf_{scale_factor}_it_{it_num}.csv'), index=False)
    print(f"query stats for scale factor {scale_factor} saved successfully")
    cur.close()
    conn.close()

parser = argparse.ArgumentParser()

# flags for obtaining and cleaning the data files
parser.add_argument("-rp", "--root_path", help="enter the root directory path")
parser.add_argument("-qp", "--query_path", help="enter the path of all data files")
# parser.add_argument("-i", "--iteration_num", help="enter the iteration num")
parser.add_argument("-sf", "--scale_factor", help="enter the path of all data files")

args = parser.parse_args()

# defining the parameters
root_path= args.root_path
query_path= args.query_path
scale_factor= args.scale_factor

# setting the iteration number for the test
current_it, current_run= iteration_number(root_path= root_path)

# print start
print("----------------------------------------------")
print(f"ITERATION {current_it}: STARTING POWER TEST")
print("----------------------------------------------") 

# Defining the connection parameters
db_params = {
    "host": "localhost",
    "database": f"tpcds_sf_{scale_factor}",
    "user": "postgres",
    "password": "1*@#Saymyname"
}

# Establish a connection to the PostgreSQL database
try:
    conn = pg.connect(**db_params)
    print("Connected to the database")
except Exception as e:
    print(f"Error: {e}")

# Create a cursor object to interact with the database
cur = conn.cursor()
# printing the version 
cur.execute("SELECT version();")
print("PostgreSQL version:")
print(cur.fetchone())

# executing the queries
st_time= datetime.now()
execute_queries(root_path= root_path, sql_folder= query_path, scale_factor= scale_factor, it_num=current_it)
end_time= datetime.now()

# calculate the total execution time
exec_time = (end_time - st_time).total_seconds()
exec_time_minutes= exec_time/60

# logging the results into a text file
with open(os.path.join(root_path, f"power_test_stats_sf_{scale_factor}.txt"), "a") as f:
    f.write(f"Iteration {current_it}: Total time taken to execute power test on 99 queries with scale factor {scale_factor}= {exec_time} seconds\n")

# logging the execution times
print(f"total time taken: {exec_time_minutes} minutes")

# Close the cursor and the connection when you're done
cur.close()
conn.close()