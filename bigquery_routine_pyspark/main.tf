resource "google_bigquery_dataset" "test" {
  dataset_id = "dataset_id-${local.name_suffix}"
}

resource "google_bigquery_connection" "test" {
  connection_id = "connection_id-${local.name_suffix}"
  location      = "US"
  spark { }
}

resource "google_bigquery_routine" "pyspark" {
  dataset_id      = google_bigquery_dataset.test.dataset_id
  routine_id      = "routine_id-${local.name_suffix}"
  routine_type    = "PROCEDURE"
  language        = "PYTHON"
  definition_body = <<-EOS
    from pyspark.sql import SparkSession

    spark = SparkSession.builder.appName("spark-bigquery-demo").getOrCreate()
    
    # Load data from BigQuery.
    words = spark.read.format("bigquery") \
      .option("table", "bigquery-public-data:samples.shakespeare") \
      .load()
    words.createOrReplaceTempView("words")
    
    # Perform word count.
    word_count = words.select('word', 'word_count').groupBy('word').sum('word_count').withColumnRenamed("sum(word_count)", "sum_word_count")
    word_count.show()
    word_count.printSchema()
    
    # Saving the data to BigQuery
    word_count.write.format("bigquery") \
      .option("writeMethod", "direct") \
      .save("wordcount_dataset.wordcount_output")
  EOS
  spark_options {
    connection          = google_bigquery_connection.test.name
    runtime_version     = "2.1"
  }
}
