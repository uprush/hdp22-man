-- load data into the table
LOAD DATA INPATH '/user/hive/twitter_data.txt' OVERWRITE INTO TABLE tweets;
