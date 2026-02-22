from datetime import datetime

from airflow.providers.cncf.kubernetes.operators.spark_kubernetes import SparkKubernetesOperator
from airflow.sdk import DAG


with DAG(
    dag_id="spark_pi_example",
    start_date=datetime(2026, 2, 18),
    schedule="0 3 * * *",
    catchup=False,
    tags=["spark"],
) as dag:
    spark_submit = SparkKubernetesOperator(
        task_id="run_spark_pi_example",
        namespace="spark",
        application_file="spark-apps/spark-pi.yaml",
        kubernetes_conn_id="kubernetes_default",
    )
