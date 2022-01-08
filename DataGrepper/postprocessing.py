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
from os import path

import pandas as pd
from tqdm import tqdm
from tqdm.contrib.concurrent import process_map


def apply_filter_production(df):
    """
    Apply filter for Production jobs.
    """
    return df.groupby("collection_id").filter(lambda x: all(x["priority"] >= 120) and all(x["type"] not in [4, 5, 6, 7, 8]))

def apply_filter_batch(df):
    """
    Apply filter for Batch jobs.
    """
    return df.groupby("collection_id").filter(lambda x: all(x["priority"] <= 119) and all(x["type"] not in [4, 5, 7, 8]))

def normalize(line):
    """
    Convert json to pd.DataFrame
    """
    return pd.json_normalize(json.loads(line), max_level=2)

def convert_to_df(lines):
    """
    Convert lines to DataFrame.
    """
    temp_df = []
    for line in tqdm(lines):
        temp_df.extend(list(normalize(line)))
    temp_df = pd.concat(temp_df, sort = False)
    temp_df["collection_id"] = temp_df["collection_id"].astype(int)
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

def process(file_name):
    """
    Process collection_events files.
    """
    r = gzip.open(path + 'job_events' + '/' + file_name, 'rt')
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

if __name__ == "__main__":
    HEAD_PATH = "/mnt/scratch/"
    PATH = HEAD_PATH + "google_2019_data/"
    CORES = 1

    MAX_READ_SIZE = 1024

    st = time.time()
    job_events = sorted(os.listdir(path + "job_events"))

    TARGET_BATCH_JOB_FILE_NAME = "job_events_batch_df.csv"
    TARGET_PRODUCTION_JOB_FILE_NAME = "job_events_production_df.csv"

    TARGET_BATCH_SELECTED_JOB_FILE_NAME = "selected_job_events_batch.pkl"
    TARGET_PRODUCTION_SELECTED_JOB_FILE_NAME = "selected_job_events_production.pkl"

    with Manager() as manager:
        selected_batch_job_ids = manager.list()
        selected_production_job_ids = manager.list()
        process_map(process, job_events, max_workers = CORES)

    selected_batch_job_ids = set(selected_batch_job_ids)
    selected_production_job_ids = set(selected_production_job_ids)

    print("Total Number of Batch Jobs is " + len(selected_batch_job_ids))
    print("Total Number of Production Jobs is " + len(selected_production_job_ids))

    with open(path + TARGET_BATCH_SELECTED_JOB_FILE_NAME, "wb") as r:
        pickle.dump(selected_batch_job_ids, r, protocol=pickle.HIGHEST_PROTOCOL)

    with open(path + TARGET_PRODUCTION_SELECTED_JOB_FILE_NAME, "wb") as r:
        pickle.dump(selected_production_job_ids, r, protocol=pickle.HIGHEST_PROTOCOL)

    et = time.time()
    print("Filtering Job Ids took" , (et - st) / 60," minutes.")
    