# Создание ключа для Git Sync Airflow

```bash
ssh-keygen -t rsa -b 4096 -C "airflow@otus.com" -f ./airflow_gitsync_id_rsa

kubectl create secret generic airflow-ssh-secret \
  --from-file=gitSshKey=./airflow_gitsync_id_rsa \
  --namespace airflow \
  --dry-run=client -o yaml > airflow-ssh-secret.yaml
  
kubectl apply -f airflow-ssh-secret.yaml
```

Добавить публичный ключ в deploy keys!


# Установка Airflow

```bash
helm repo add apache-airflow https://airflow.apache.org
helm repo update
helm upgrade --install airflow apache-airflow/airflow --values values.yml --version 1.19.0 --namespace airflow --create-namespace

helm delete airflow --namespace airflow
```

Values here: https://github.com/apache/airflow/blob/main/chart/values.yaml 



# Сборка образа и push (выполнять из директории airflow)

```bash
docker buildx build --platform linux/amd64 -t cr.yandex/crpeqnl53oh327o27qtu/apache/airflow:3.1.7-python3.12 .
docker push cr.yandex/crpeqnl53oh327o27qtu/apache/airflow:3.1.7-python3.12
```

# Установка Spark Operator

```bash
helm repo add spark-operator https://kubeflow.github.io/spark-operator
helm repo update spark-operator
helm repo list | grep spark-operator

kubectl get namespace spark || kubectl create namespace spark

helm install spark-operator spark-operator/spark-operator --namespace spark-operator --create-namespace -f spark-operator-values.yaml

kubectl apply -f airflow-spark-rbac.yaml
```

Для проверки, что оператор работает корректно:
```bash
kubectl apply -f dags/spark-apps/spark-pi.yaml
```


# Удаление Spark Operator
```bash
helm uninstall spark-operator -n spark-operator
```







https://medium.com/@nsalexamy/running-spark-applications-on-kubernetes-with-spark-operator-and-airflow-3-0-adf7d01a1023