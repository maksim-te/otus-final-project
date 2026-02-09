```bash
helm repo add apache-airflow https://airflow.apache.org
helm repo update
helm upgrade --install airflow apache-airflow/airflow --values values.yml --version 1.19.0 --namespace airflow --create-namespace

helm delete airflow --namespace airflow
```

https://github.com/apache/airflow/blob/main/chart/values.yaml 