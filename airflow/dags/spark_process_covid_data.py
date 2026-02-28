from datetime import datetime

from airflow.hooks.base import BaseHook
from airflow.providers.cncf.kubernetes.operators.spark_kubernetes import SparkKubernetesOperator
from airflow.providers.cncf.kubernetes.hooks.kubernetes import KubernetesHook
from airflow.sdk import DAG
from airflow.operators.python import PythonOperator

from airflow.sdk import Connection
from airflow.settings import Session

def get_connection(conn_id: str):
    with Session() as session:
        return session.query(Connection).filter(
            Connection.conn_id == conn_id
        ).one()

from kubernetes import client
import base64

NAMESPACE = "spark"
SECRET_NAME = "clickhouse-credentials"

def create_clickhouse_secret():
    conn = BaseHook.get_connection("clickhouse_default")

    data = {
        "CH_HOSTNAME": conn.host,
        "CH_PORT": str(conn.port or 8123),
        "CH_USERNAME": conn.login,
        "CH_PASSWORD": conn.password,
    }

    encoded_data = {
        k: base64.b64encode(v.encode()).decode()
        for k, v in data.items()
    }

    secret = client.V1Secret(
        metadata=client.V1ObjectMeta(
            name=SECRET_NAME,
            namespace=NAMESPACE,
        ),
        type="Opaque",
        data=encoded_data,
    )

    hook = KubernetesHook(conn_id="kubernetes_default")
    api = hook.get_conn()

    try:
        api.create_namespaced_secret(namespace=NAMESPACE, body=secret)
    except client.exceptions.ApiException as e:
        if e.status == 409:
            api.replace_namespaced_secret(
                name=SECRET_NAME,
                namespace=NAMESPACE,
                body=secret,
            )
        else:
            raise

with DAG(
    dag_id="spark_process_covid_data",
    start_date=datetime(2026, 2, 18),
    schedule="0 3 * * *",
    catchup=False,
    tags=["spark"],
) as dag:

    create_secret = PythonOperator(
        task_id="create_clickhouse_secret",
        python_callable=create_clickhouse_secret,
    )

    spark_submit = SparkKubernetesOperator(
        task_id="process_covid_data",
        namespace="spark",
        application_file="spark-apps/spark-covid-data-app.yaml",
        kubernetes_conn_id="kubernetes_default",
    )

    create_secret >> spark_submit
