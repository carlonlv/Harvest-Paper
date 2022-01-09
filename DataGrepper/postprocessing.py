"""
Posprocessing for google open dataset
https://drive.google.com/file/d/10r6cnJ5cJ89fPWCgj7j4LtLBqYN9RiI9/view.
"""

import gzip
import json
import os
import pickle
import time
from multiprocessing import Manager

import pandas as pd
from tqdm.contrib.concurrent import process_map


def apply_filter_production(df):
    """
    Apply filter for Production jobs.
    """
    return df.groupby("collection_id").filter(lambda x: (x["priority"] >= 120).all() and not x["type"].isin([4, 5, 6, 7, 8]).any())

def apply_filter_batch(df):
    """
    Apply filter for Batch jobs.
    """
    return df.groupby("collection_id").filter(lambda x: (x["priority"] <= 119).all() and not x["type"].isin([4, 5, 7, 8]).any())

def convert_to_df(lines):
    """
    Convert lines to DataFrame.
    """
    temp_df = []
    for line in lines:
        temp_df.append(json.loads(line))
    temp_df = pd.json_normalize(temp_df, max_level=3)
    temp_df["collection_id"] = temp_df["collection_id"].astype(int)
    temp_df["instance_index"] = temp_df["instance_index"].astype(int)
    temp_df["priority"] = temp_df["priority"].astype(int)
    temp_df["type"] = temp_df["type"].astype(int)
    temp_df["collection_type"] = temp_df["collection_type"].astype(int)
    return temp_df

def write_df(df, target_fp):
    """
    Write parsed Dataframe.
    """
    if os.path.exists(target_fp):
        df.to_csv(target_fp, mode = 'a', header = False)
    else:
        df.to_csv(target_fp, header = True)

def process_job_events(file_name):
    """
    Process collection_events files.
    """
    r = gzip.open(PATH + "job_events/" + file_name, 'rt')
    r.seek(0, 0)
    while True:
        l = r.readlines(MAX_READ_SIZE)
        if not l:
            break
        tt_df = convert_to_df(l)
        batch_df = apply_filter_batch(tt_df)
        production_df = apply_filter_production(tt_df)

        write_df(batch_df, PATH + "parsed_job_events/" + TARGET_BATCH_JOB_FILE_NAME)
        write_df(production_df, PATH + "parsed_job_events/" + TARGET_PRODUCTION_JOB_FILE_NAME)

        selected_batch_job_ids.extend((batch_df.loc[:,"collection_id"]).tolist())
        selected_production_job_ids.extend((production_df.loc[:,"collection_id"]).tolist())

def process_task_events(file_name):
    """
    Process instance_events files.
    """
    r = gzip.open(PATH + "task_events/" + file_name, 'rt')
    r.seek(0, 0)
    while True:
        l = r.readlines(MAX_READ_SIZE)
        if not l:
            break
        tt_df = convert_to_df(l)
        batch_df = tt_df.loc[tt_df["collection_id"].isin(selected_batch_job_ids)]
        production_df = tt_df.loc[tt_df["collection_id"].isin(selected_production_job_ids)]

        write_df(batch_df, PATH + "parsed_task_events/" + TARGET_BATCH_TASK_FILE_NAME)
        write_df(production_df, PATH + "parsed_task_events/" + TARGET_PRODUCTION_TASK_FILE_NAME)

def process_task_usage(file_name):
    """
    Process and Consume task usage files.
    """
    r = gzip.open(PATH + "task_usage/" + file_name, 'rt')
    r.seek(0, 0)
    while True:
        l = r.readlines(MAX_READ_SIZE)
        if not l:
            break
        tt_df = convert_to_df(l)
        batch_df = tt_df.loc[tt_df["collection_id"].isin(selected_batch_job_ids) & tt_df["instance_index"] == 0]
        production_df = tt_df.loc[tt_df["collection_id"].isin(selected_production_job_ids) & tt_df["instance_index"] == 0]

        write_df(batch_df, PATH + "parsed_task_usage/" + TARGET_BATCH_TASK_USAGE_FILE_NAME)
        write_df(production_df, PATH + "parsed_task_usage/" + TARGET_PRODUCTION_TASK_USAGE_FILE_NAME)
    os.remove(file_name)

if __name__ == "__main__":
    HEAD_PATH = "/mnt/scratch/"
    PATH = HEAD_PATH + "google_2019_data/"

    CORES = 28

    MAX_READ_SIZE = 1 * (1024 ** 3)

    TARGET_BATCH_JOB_FILE_NAME = "job_events_batch_df.csv"
    TARGET_PRODUCTION_JOB_FILE_NAME = "job_events_production_df.csv"

    TARGET_BATCH_TASK_FILE_NAME = "task_events_batch_df.csv"
    TARGET_PRODUCTION_TASK_FILE_NAME = "task_events_production_df.csv"

    TARGET_BATCH_TASK_USAGE_FILE_NAME = "task_usage_batch_df.csv"
    TARGET_PRODUCTION_TASK_USAGE_FILE_NAME = "task_usage_production_df.csv"

    TARGET_BATCH_SELECTED_JOB_FILE_NAME = "selected_job_events_batch.pkl"
    TARGET_PRODUCTION_SELECTED_JOB_FILE_NAME = "selected_job_events_production.pkl"

    ## Section 1: Job Events
    st = time.time()
    job_events = sorted(os.listdir(PATH + "job_events"))

    with Manager() as manager:
        selected_batch_job_ids = manager.list()
        selected_production_job_ids = manager.list()
        process_map(process_job_events, job_events, max_workers = CORES)

        selected_batch_job_ids = set(selected_batch_job_ids)
        selected_production_job_ids = set(selected_production_job_ids)

        print("Total Number of Batch Jobs is " + str(len(selected_batch_job_ids)))
        print("Total Number of Production Jobs is " + str(len(selected_production_job_ids)))

        with open(PATH + TARGET_BATCH_SELECTED_JOB_FILE_NAME, "wb") as f:
            pickle.dump(selected_batch_job_ids, f, protocol=pickle.HIGHEST_PROTOCOL)

        with open(PATH + TARGET_PRODUCTION_SELECTED_JOB_FILE_NAME, "wb") as f:
            pickle.dump(selected_production_job_ids, f, protocol=pickle.HIGHEST_PROTOCOL)

    et = time.time()
    print("Processing Job Events took" , (et - st) / 60," minutes.")

    ## Section 2: Task Events
    with open(PATH + TARGET_BATCH_SELECTED_JOB_FILE_NAME, "rb") as f:
        selected_batch_job_ids = pickle.load(f)
    with open(PATH + TARGET_PRODUCTION_SELECTED_JOB_FILE_NAME, "rb") as f:
        selected_production_job_ids = pickle.load(f)
    st = time.time()
    task_events = sorted(os.listdir(PATH + "task_events"))
    process_map(process_task_events, task_events, max_workers = CORES)
    et = time.time()
    print("Processing Task Events took" , (et - st) / 60," minutes.")

    ## Section 3: Task Usage
    with open(PATH + TARGET_BATCH_SELECTED_JOB_FILE_NAME, "rb") as f:
        selected_batch_job_ids = pickle.load(f)
    with open(PATH + TARGET_PRODUCTION_SELECTED_JOB_FILE_NAME, "rb") as f:
        selected_production_job_ids = pickle.load(f)
    st = time.time()
    task_usage = sorted(os.listdir(PATH + "task_usage"))
    process_map(process_task_usage, task_usage, max_workers = CORES)
    et = time.time()
    print("Processing Task Usage took" , (et - st) / 60," minutes.")
