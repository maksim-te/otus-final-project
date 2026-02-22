FROM apache/airflow:3.1.7-python3.12

USER airflow

RUN pip install --no-cache-dir \
    --constraint https://raw.githubusercontent.com/apache/airflow/constraints-3.1.7/constraints-3.12.txt \
    apache-airflow-providers-fab==3.2.0 \
    apache-airflow-providers-apache-spark==5.5.0 \
    apache-airflow-providers-cncf-kubernetes==10.12.3

COPY --chown=airflow:root dags/ /opt/airflow/dags/
COPY --chown=airflow:root jars/ /opt/jars/
