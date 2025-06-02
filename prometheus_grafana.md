### Установка Prometheus и Grafana на CentOS в VirtualBox с доступом из основной ОС Ubuntu

#### 1. Настройка сети в VirtualBox
- **Тип сети**: Используйте **NAT** с пробросом портов или **Сетевой мост** (Bridged Adapter).
  - **Рекомендуется**: NAT с пробросом портов для SSH, Prometheus и Grafana.

**Проброс портов (NAT)**:
1. В VirtualBox откройте настройки виртуальной машины CentOS.
2. Перейдите в раздел **Сеть** → **Дополнительно** → **Проброс портов**.
3. Добавьте правила:
   - **SSH**: 
     - Имя: `SSH`
     - Протокол: TCP
     - Порт хоста: `2222` → Порт гостевой ОС: `22`
   - **Prometheus**:
     - Имя: `Prometheus`
     - Протокол: TCP
     - Порт хоста: `9090` → Порт гостевой ОС: `9090`
   - **Grafana**:
     - Имя: `Grafana`
     - Протокол: TCP
     - Порт хоста: `3000` → Порт гостевой ОС: `3000`

#### 2. Настройка SSH на CentOS
1. Установите SSH-сервер (если не установлен):
   ```bash
   sudo yum install openssh-server
   sudo systemctl start sshd
   sudo systemctl enable sshd
   ```
2. Проверьте подключение с хоста Ubuntu:
   ```bash
   ssh -p 2222 username@localhost
   ```

#### 3. Установка Prometheus
1. Скачайте и установите Prometheus:
   ```bash
   wget https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-amd64.tar.gz
   tar xvf prometheus-*.tar.gz
   sudo mv prometheus-2.47.0.linux-amd64 /opt/prometheus
   ```
2. Создайте файл конфигурации `/opt/prometheus/prometheus.yml`:
   ```yaml
   global:
     scrape_interval: 15s
   scrape_configs:
     - job_name: 'prometheus'
       static_configs:
         - targets: ['localhost:9090']
     - job_name: 'postgres'  # Добавьте позже после настройки postgres_exporter
       static_configs:
         - targets: ['localhost:9187']
   ```
3. Создайте systemd-сервис `/etc/systemd/system/prometheus.service`: (юнит не работает)
   ```ini
   [Unit]
   Description=Prometheus
   After=network.target

   [Service]
   User=root
   ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```
4. Используем костыль: пишем скрипт /opt/prometheus/prometheus.sh , делаем его исполняемым.
      Добавляем строку в /etc/rc.d/rc.local
      /opt/prometheus/prometheus.sh

      Проверяем, что rc есть в автозапуске и проверяем, что прометей запустился вместе с ним
      sudo systemctl enable rc-local
      sudo systemctl start rc-local


5. Запустите Prometheus (если всё таки ЮНИТ заработал)
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start prometheus
   sudo systemctl enable prometheus
   ```

#### 4. Установка postgres_exporter на Ubuntu (хост с PostgreSQL)
1. Скачайте и установите экспортер:
   ```bash
   wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.14.0/postgres_exporter-0.14.0.linux-amd64.tar.gz
   tar xvf postgres_exporter-*.tar.gz
   sudo mv postgres_exporter-0.14.0.linux-amd64 /opt/postgres_exporter
   ```

2. Создайте файл с переменными окружения `/etc/default/postgres_exporter`:
   ```bash
   DATA_SOURCE_NAME="postgresql://postgres_user:password@localhost:5432/postgres?sslmode=disable"
   ```
   - Замените `postgres_user` и `password` на актуальные данные пользователя PostgreSQL.

3. Создайте systemd-сервис `/etc/systemd/system/postgres_exporter.service`:
   ```ini
   [Unit]
   Description=Postgres Exporter
   After=network.target

   [Service]
   User=postgres  # Лучше запускать от пользователя PostgreSQL
   EnvironmentFile=/etc/default/postgres_exporter
   ExecStart=/opt/postgres_exporter/postgres_exporter
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

4. Запустите экспортер:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start postgres_exporter
   sudo systemctl enable postgres_exporter
   ```

5. Откройте порт **9187** на Ubuntu для доступа с виртуалки CentOS:
   ```bash
   sudo ufw allow from <IP_виртуалки_CentOS> to any port 9187
   ```

6. На виртуалке CentOS проверьте доступ к postgres_exporter:
   ```bash
   curl http://<IP_Ubuntu>:9187/metrics
   ```
   - Должны отобразиться метрики PostgreSQL.

- **Ubuntu (хост)**:
  - Для доступа из CentOS используйте **`10.0.2.2`** (стандартный шлюз в NAT VirtualBox).

- **CentOS (гость)**:
  - Внутренний IP в NAT-сети VirtualBox (обычно `10.0.2.15`). Проверьте его в CentOS:
    ```bash
    ip a
    ``
---

#### 5. Установка Grafana
1. Добавьте репозиторий Grafana:
    создать файл /etc/yum.repos.d/grafana.repo с содержанием:
    [grafana]
    name=grafana
    baseurl=https://rpm.grafana.com
    repo_gpgcheck=1
    enabled=1
    gpgcheck=1
    gpgkey=https://rpm.grafana.com/gpg.key
    sslverify=1
    sslcacert=/etc/pki/tls/certs/ca-bundle.crt

2. Установите Grafana:
   ```bash
   sudo yum install grafana
   sudo systemctl start grafana-server
   sudo systemctl enable grafana-server
   ```

#### 7. Настройка firewall на CentOS
```bash
sudo firewall-cmd --permanent --add-port=22/tcp
sudo firewall-cmd --permanent --add-port=9090/tcp
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload
```

#### 8. Проверка доступности
- **Prometheus**: Откройте в браузере на хосте Ubuntu: `http://localhost:9090`.
- **Grafana**: Откройте `http://localhost:3000` (логин: `admin`, пароль: `admin`).

#### 9. Настройка Grafana
1. Добавьте источник данных **Prometheus**:
   - URL: `http://localhost:9090` (изнутри виртуалки CentOS).
2. Импортируйте дашборды для PostgreSQL (например, ID `9628`).

---

**Примечания**:
- Если используется **Bridged Adapter**, замените `localhost` на IP-адрес виртуалки CentOS.
- Для отладки проверьте логи служб:
  ```bash
  journalctl -u prometheus -f
  journalctl -u grafana-server -f
  ```