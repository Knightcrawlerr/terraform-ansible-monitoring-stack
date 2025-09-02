# Terraform + Ansible Monitoring Stack

This project demonstrates a **production-like monitoring and alerting setup** using **Terraform, Ansible, Prometheus, Grafana, and Alertmanager**.  
The goal is to build hands-on experience in deploying and automating monitoring for dynamic infrastructure.  

---

## 🚀 Project Overview

- **Terraform** provisions the infrastructure:
  - One **monitoring server** (Prometheus, Grafana, Alertmanager, Node Exporter)  
  - One or more **application servers** (MySQL, Node Exporter, MySQL Exporter, Sysbench for load testing)

- **Ansible** configures the servers:
  - Installs Prometheus, Grafana, and Alertmanager on the monitoring server  
  - Installs MySQL, Node Exporter, and MySQL Exporter on the app servers  

- **Prometheus** scrapes metrics from exporters  
- **Alertmanager** handles alert notifications  
- **Grafana** provides dashboards and visualization  

This setup simulates what you would see in a real production monitoring environment.

---

## 📂 Project Structure

```
terraform-ansible-monitoring-stack/
├── terraform/              # Infrastructure as Code (servers, networking, security groups)
├── ansible/                # Configuration management
│   ├── roles/              # Roles for monitoring + app servers
│   └── playbooks/          # Ansible playbooks
├── prometheus/             # Prometheus configs (scrape targets, alert rules)
│   ├── prometheus.yml
│   └── alert.rules.yml
└── README.md               # Project documentation
```

---

## 🔧 Components

- **Prometheus** → scrapes metrics (CPU, memory, disk, MySQL, etc.)  
- **Node Exporter** → system-level metrics (CPU, memory, disk, load)  
- **MySQL Exporter** → database-level metrics (availability, queries, replication lag)  
- **Alertmanager** → sends alerts (e.g., high CPU, low memory, MySQL down)  
- **Grafana** → dashboards and visualization  

---

## 📊 Example Alerts

- High CPU usage  
- High memory consumption  
- High load average  
- Disk usage above threshold  
- MySQL service down  

---

## 🔑 Skills Demonstrated

- Infrastructure automation with **Terraform**  
- Server configuration with **Ansible**  
- Monitoring and alerting using **Prometheus & Alertmanager**  
- Observability dashboards with **Grafana**  
- Hands-on simulation of a **production-like environment**  

---

## 🏗️ Architecture

```
                 +----------------------+
                 |   Monitoring Server  |
                 |----------------------|
                 |  Prometheus          |
                 |  Grafana             |
                 |  Alertmanager        |
                 |  Node Exporter       |
                 +----------+-----------+
                            |
                            | Scrape / Alerts
                            v
         +------------------------------------------+
         |              Application Servers         |
         |------------------------------------------|
         |  MySQL + Sysbench                        |
         |  Node Exporter                           |
         |  MySQL Exporter                          |
         +------------------------------------------+
```

---

## 🚦 Getting Started (High-Level)

1. **Provision infrastructure** with Terraform  
2. **Run Ansible playbooks** to install and configure services  
3. Access services:  
   - Prometheus → `http://<monitor-server>:9090`  
   - Grafana → `http://<monitor-server>:3000`  
   - Alertmanager → `http://<monitor-server>:9093`  

---

## 📌 Future Enhancements

- Add Slack/Email integration for alerts  
- Extend exporters (Blackbox Exporter for website uptime, Redis Exporter, etc.)  
- Add Terraform modules for multi-cloud support  
- Create Grafana dashboards for MySQL performance  
