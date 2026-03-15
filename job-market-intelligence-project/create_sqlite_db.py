import pandas as pd
import sqlite3

# load cleaned dataset
df = pd.read_csv("data/processed/job_market_dataset.csv")

# create sqlite database
conn = sqlite3.connect("job_market.db")

# create table and load data
df.to_sql("job_market", conn, if_exists="replace", index=False)

print("SQLite database created successfully!")

conn.close()

