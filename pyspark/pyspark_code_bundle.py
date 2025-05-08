# Note - File should be present in the gateway node
# spaces and spelling matter - You might get syntax issue (space after "\" in each lie,coreS)

# command to trigger this file
# spark-submit \
# --master yarn \
# --num-executors 2 \
# --executor-cores 2 \
# --executor-memory 4G \
# --conf spark.dynamicAllocation.enabled=false \
# pyspark_code_bundle.py

from pyspark.sql import SparkSession
import getpass
username = getpass.getuser()
spark= SparkSession. \
builder. \
config('spark.ui.port','0'). \
config("spark.sql.warehouse.dir", f"/user/{username}/warehouse"). \
enableHiveSupport(). \
master('yarn'). \
getOrCreate()


from pyspark.sql.types import StructType, StructField, StringType,IntegerType,ArrayType
#creating schema for reading the json file
IntegerType, ArrayType
users_schema = StructType([
StructField("user_id", IntegerType(), nullable=False),
StructField("user_first_name", StringType(), nullable=False),
StructField("user_last_name", StringType(), nullable=False),
StructField("user_email", StringType(), nullable=False),
StructField("user_gender", StringType(), nullable=False),
StructField("user_phone_numbers", ArrayType(StringType()),
nullable=True),
StructField("user_address", StructType([
StructField("street", StringType(), nullable=False),
StructField("city", StringType(), nullable=False),
StructField("state", StringType(), nullable=False),
StructField("postal_code", StringType(), nullable=False),
]), nullable=False)
])


base_df = spark.read \
.format('json') \
.options(schema=users_schema) \
.load("/public/sms/users/*")

# 1)Do check how many partitions are created  in your dataframe.
base_df.rdd.getNumPartitions()

# 2) Do some basic analysis and find out the following
base_df.show(truncate=False)

from pyspark.sql.functions import col,size
base_df.withColumn("user_street",col("user_Address.street")) \
.withColumn("user_city",col("user_address.city")) \
.withColumn("user_state", col("user_Address.state")) \
.withColumn("user_postal_code", col("user_address.postal_code")) \
.withColumn("num_phn_numbers",
size(col("user_phone_numbers"))).createOrReplaceTempView("users_vw")

spark.sql("select * from users_vw")

# a. total number of records in the dataframe
spark.sql("select count(*) from users_vw")

# b. how many users are from the state New York
spark.sql("select count(distinct user_id) as unique_id from users_vw where user_state = 'New York' ")

#  c. which state has maximum number of postal codes
spark.sql("""select user_state,count(distinct user_postal_Code) as postal_cnt
from users_vw
group by user_state order by postal_cnt desc limit 1""")

#  d. which city has the most number of users
spark.sql(''' select user_city, count(distinct user_id) as uniq_id  from users_vw
where user_city is not null 
group by user_city 
order by uniq_id desc limit 1
''')

# e. how many users have email domain as bizjournals.com
spark.sql(''' select count(*) as  from users_vw
where user_email like '%bizjournals.com'  
''')

# f. how many users have 4 phone numbers mentioned
spark.sql(''' select count(*)  from users_vw
where num_phn_numbers = 4
''')

#  g. how many users do not have any phone number mentioned
spark.sql(''' select count(*)  from users_vw
where user_phone_numbers is null
''')

# Question 3
#  Write the data from the base dataframe as it is to the disk, but write in parquet format. Observe the number of files created, also the size of files.
base_df.write \
.format("parquet") \
.mode("overwrite") \
.option("path","/user/itv011856/w9_assignment1") \
.save()


print("process successfull")