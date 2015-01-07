-- create tweets table
CREATE TABLE IF NOT EXISTS tweets
(
  user STRUCT<
    userlocation:STRING,
    id:INT,
    name:STRING,
    screenname:STRING,
    geoenabled:BOOLEAN>,
  tweetmessage STRING,
  createddate STRING,
  geolocation STRING
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE;
