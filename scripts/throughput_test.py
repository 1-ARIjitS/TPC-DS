import psycopg2 as pg
from psycopg2 import sql
import os
import pandas as pd
from datetime import datetime
import argparse
import re
# import future
# from concurrent.futures import ThreadPoolExecutor
import threading
import tqdm
import random

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

# Function to extract the query number
def extract_query_num(filename):
    res= re.split("[ _ | . ]", filename)
    num= int(res[1])
    return num

# defining the query num
# current_query_num= 0

# Function to execute SQL queries and log execution times
def execute_queries(client_id, root_path, query_path, query_list, scale_factor, it_num, run_num):
    conn = pg.connect(**db_params)
    cur = conn.cursor()
    wrong_query_list=[]
    stats_list=[]

    # with tqdm(total= 4*len(query_list)) as pbar:
    for filename in query_list:
        query_file = os.path.join(query_path, filename)

        with open(query_file, 'r') as file:
            query = file.read()

        try:
            start_time = datetime.now()
            cur.execute(query)
            # current_query_num+=1
            conn.commit()
            end_time = datetime.now()
            execution_time = (end_time - start_time).total_seconds()
            stats_list.append([filename, start_time, end_time, execution_time])
            # pbar.set_postfix(file=filename, start=start_time, end=end_time, time=execution_time)
            # pbar.update(1)
            print(f"client_{client_id}: '{filename}' executed successfully in {execution_time} seconds.")

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
        
    print("saving the pandas dataframe to a csv...")
    df= pd.DataFrame(stats_list, columns=["Query File", "Start Time", "End Time", "Execution Time"])
    df.to_csv(os.path.join(root_path, f'throughput_test_stats_sf_{scale_factor}_client_{client_id}_it_{it_num}_run_{run_num}.csv'), index=False)
    print(f"query stats for scale factor {scale_factor} and client_id {client_id} saved successfully")
    cur.close()
    conn.close() 

# parser to add arguments
parser = argparse.ArgumentParser()

# flags for obtaining and cleaning the data files
parser.add_argument("-rp", "--root_path", help="enter the root directory path")
parser.add_argument("-qp", "--query_path", help="enter the path of all data files")
parser.add_argument("-sf", "--scale_factor", help="enter the path of all data files i.e. [1,3,5,10]")

args = parser.parse_args()

# defining the parameters
root_path= args.root_path
query_path= args.query_path
scale_factor= args.scale_factor

# setting the iteration number for the test
current_it, current_run= iteration_number(root_path= root_path)

# print start
print("---------------------------------------------------------------------")
print(f"ITERATION {current_it}: STARTING THE THROUGHPUT TEST {current_run}")
print("---------------------------------------------------------------------")

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

# Number of clients and queries to simulate
num_clients = 4
queries_per_client = 99

# creating 4 threads for 4 parallel clients
threads = []
query_list= []

# iterating over all the files and appending the slq files into the query list
for filename in os.listdir(query_path):
    if filename.endswith(".sql"):
        query_list.append(filename)

for client_id in range(1, num_clients+1):
    # setting a random seed to make the code reproducible
    random.seed(client_id)

    # creating a random query list
    random_query_list= query_list.copy()
    random.shuffle(random_query_list)
    print(f"random query list for client_{client_id} is- \n {random_query_list}")

    # creating a thread for a client
    thread = threading.Thread(target=execute_queries, args=(client_id, root_path, query_path, random_query_list,  scale_factor, current_it, current_run))
    threads.append(thread)
    start_time= datetime.now()
    thread.start()

# closing the threads
for thread_num, thread in enumerate(threads):
    thread.join()
    end_time= datetime.now()
    exec_time= (end_time - start_time).total_seconds()
    with  open(os.path.join(root_path, f"throughput_test_stats_sf_{scale_factor}.txt"), "a") as f:
        f.write(f"Iteration {current_it}: Total time taken by thread_{thread_num+1} {thread} for running 99 queries= {exec_time} seconds \n")
    print(f"thread {thread_num+1} takes {exec_time} seconds")

# logging the final end time
total_end_time= datetime.now()
total_exec_time= (total_end_time - start_time).total_seconds()
with  open(os.path.join(root_path, f"throughput_test_stats_sf_{scale_factor}.txt"), "a") as f:
        f.write(f"Iteration {current_it} run {current_run}: Total time taken by throughput test= {total_exec_time} seconds \n")
print(f"total time taken by the throughput test= {total_exec_time} seconds")

# updating the run number for throughput test 1 and throughput test 2
# update_it_num(root_path, current_it, current_run)

# Close the cursor and the connection when you're done
cur.close()
conn.close()