# Trend Application Deployment on AWS EKS using DevOps CI/CD

## Overview

This project demonstrates an end-to-end DevOps implementation for deploying the **Trend** application on AWS using industry-standard DevOps tools and best practices.

The solution includes infrastructure provisioning using Terraform, application containerization with Docker, CI/CD automation using Jenkins, deployment to Amazon EKS, and monitoring using Prometheus and Grafana.

---

# Project Highlights

✅ Infrastructure Provisioning using Terraform

✅ Docker-based Application Containerization

✅ DockerHub Image Repository Integration

✅ Jenkins CI/CD Pipeline Automation

✅ GitHub Webhook Integration

✅ Amazon EKS Deployment

✅ Kubernetes LoadBalancer Exposure

✅ Prometheus Monitoring

✅ Grafana Dashboards

✅ Complete Deployment Documentation

---

# Project Repositories

## Source Application Repository

```text
https://github.com/Vennilavanguvi/Trend
```

## DevOps Repository

```text
https://github.com/Nalini-0212/Trend-devops.git
```

## DockerHub Repository

```text
https://hub.docker.com/repository/docker/naliniselv/trend/general
```

---

# Prerequisites

- AWS Account
- AWS CLI
- Terraform
- Docker
- Git
- Jenkins
- kubectl
- eksctl
- Helm
- DockerHub Account

---

# Technology Stack

## Source Control

- Git
- GitHub

## Containerization

- Docker
- DockerHub

## Infrastructure as Code

- Terraform

## CI/CD

- Jenkins

## Container Orchestration

- Kubernetes
- Amazon EKS

## Monitoring

- Prometheus
- Grafana

## Cloud Platform

- AWS

---

# Solution Architecture

```text
GitHub
   │
   ▼
GitHub Webhook
   │
   ▼
Jenkins Pipeline
   │
   ├── Checkout Repository
   ├── Build Docker Image
   ├── Validate Application
   ├── Push Image to DockerHub
   ├── Configure EKS
   ├── Deploy Kubernetes Resources
   └── Verify Deployment
               │
               ▼
         Amazon EKS
               │
               ▼
         Kubernetes Service
               │
               ▼
         AWS LoadBalancer
               │
               ▼
          Trend Application

Monitoring
   ├── Prometheus
   └── Grafana
```

---

# Deployment Workflow

1. Provision AWS infrastructure using Terraform.
2. Automatically install Jenkins on EC2 using User Data.
3. Configure GitHub repository and Jenkins integration.
4. Trigger Jenkins build using GitHub Webhooks.
5. Build Docker image through Jenkins.
6. Validate application locally.
7. Push image to DockerHub.
8. Configure EKS cluster access.
9. Deploy Kubernetes resources.
10. Update deployment with latest image.
11. Verify rollout status.
12. Expose application using AWS LoadBalancer.
13. Monitor infrastructure and application health using Prometheus and Grafana.

---

# Project Structure

```text
TREND
│
├── app/
│   └── dist/
│
├── docker/
│   └── Dockerfile
│
├── docs/
│   └── Application_Deployment.docx
│
├── jenkins/
│   └── Jenkinsfile
│
├── k8s/
│   ├── namespace.yml
│   ├── deployment.yml
│   └── service.yml
│
│
├── screenshots/
│
├── terraform/
│   ├── provider.tf
│   ├── variable.tf
│   ├── main.tf
│   └── output.tf
│
├── .dockerignore
├── .gitignore
└── README.md
```

---

# Infrastructure Provisioning using Terraform

Terraform was used to create and manage AWS infrastructure.

## Resources Created

### Networking

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route Table Association

### Security

Security Group allowing:

- SSH (22)
- HTTP (80)
- Jenkins (8080)

### IAM

- IAM Role
- IAM Instance Profile
- AdministratorAccess Policy Attachment

### Compute

- Ubuntu EC2 Instance
- Jenkins Installation
- Public IP Assignment
- 70 GB GP3 Root Volume

---

# Terraform Configuration

## provider.tf

Configures AWS Provider.

## variable.tf

Contains:

- AWS Region
- Instance Type
- Key Pair Name
- Security Group Ports
- Volume Size

## main.tf

Creates:

- VPC
- Subnet
- Internet Gateway
- Route Table
- Security Group
- IAM Components
- EC2 Instance
- Jenkins Installation

## output.tf

Displays Jenkins Public IP.

```hcl
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.jenkins_instance.public_ip
}
```

---

# Terraform Commands

Initialize Terraform:

```bash
terraform init
```

Validate Configuration:

```bash
terraform validate
```

Generate Execution Plan:

```bash
terraform plan
```

Provision Infrastructure:

```bash
terraform apply -auto-approve
```

View Outputs:

```bash
terraform output
```

---

# Jenkins Setup

Jenkins was installed automatically on the EC2 instance using Terraform User Data.

Access Jenkins:

http://<JENKINS_PUBLIC_IP>:8080


## Plugins Installed

- Git Plugin
- Pipeline Plugin
- Docker Plugin
- Docker Pipeline Plugin
- Kubernetes Plugin
- AWS Credentials Plugin
- Blue Ocean Plugin

---

# Docker Implementation

## Dockerfile

```dockerfile
FROM nginx:alpine3.23

COPY app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

## Build Docker Image

```bash
docker build -f docker/Dockerfile -t naliniselv/trend:latest .
```

## Run Container

```bash
docker run -d -p 3000:80 naliniselv/trend:latest
```

## Verify Application

```bash
curl -I http://localhost:3000
```

---

# DockerHub

Docker images are stored in DockerHub.

Repository:

```text
https://hub.docker.com/repository/docker/naliniselv/trend/general
```

Push Image:

```bash
docker push naliniselv/trend:latest
```

---

# Version Control

GitHub repository:

```text
https://github.com/Nalini-0212/Trend-devops.git
```

Push Changes:

```bash
git add .

git commit -m "Updated DevOps Project"

git push origin main
```

---

# Amazon EKS Cluster

## Cluster Details

```text
Cluster Name : trend-cluster
Region       : ap-south-1
```

Verify Cluster:

```bash
kubectl get nodes
```

Expected:

```text
Ready
```

---

# Kubernetes Deployment

## Namespace

```text
trend
```

## Deployment

```text
trend-deployment
```

### Configuration

- Replicas: 2
- Image: naliniselv/trend:latest
- Container Port: 80

Deploy:

```bash
kubectl apply -f k8s/namespace.yml

kubectl apply -f k8s/deployment.yml
```

Verify:

```bash
kubectl get deployments -n trend

kubectl get pods -n trend
```

---

# Kubernetes Service

## Service Name

```text
trend-service
```

## Service Type

```text
LoadBalancer
```

### Service Configuration

```yaml
port: 3000
targetPort: 80
```

Deploy:

```bash
kubectl apply -f k8s/service.yml
```

Verify:

```bash
kubectl get svc -n trend
```

---

# Jenkins CI/CD Pipeline

A Jenkins Declarative Pipeline was implemented to automate application deployment.

## Pipeline Flow

1. Checkout source code from GitHub
2. Generate Docker image version
3. DockerHub authentication
4. Build Docker image
5. Validate application locally
6. Push image to DockerHub
7. Configure Amazon EKS access
8. Verify EKS cluster
9. Deploy Kubernetes manifests
10. Update deployment image
11. Verify rollout status
12. Retrieve LoadBalancer information

## Deployment Verification

```bash
kubectl rollout status deployment/trend-deployment -n trend
```

---

# Application Deployment

The application was successfully deployed to Amazon EKS and exposed using a Kubernetes LoadBalancer Service.

## Application URL

```text
http://a964149113c184893b7e0ac5a158274d-505284856.ap-south-1.elb.amazonaws.com
```

## Deployment Verification

```bash
kubectl get svc -n trend
```

The application was validated successfully through the external LoadBalancer endpoint.


## EKS Service Verification

```bash
kubectl get svc -n trend
```

Sample Output:

```text
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP                                                               PORT(S)          AGE   SELECTOR
trend-service   LoadBalancer   10.100.23.10   a964149113c184893b7e0ac5a158274d-505284856.ap-south-1.elb.amazonaws.com   3000:31425/TCP   83s   app=trend-app
```


---

# Monitoring

An open-source monitoring solution was implemented using Prometheus and Grafana.

## Monitoring Components

- Prometheus
- Grafana
- AlertManager
- kube-state-metrics
- Node Exporter

---

# Monitoring Installation

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install monitoring \
prometheus-community/kube-prometheus-stack \
-n monitoring \
--create-namespace
```

---

# Monitoring Access

Prometheus and Grafana were exposed externally using Kubernetes LoadBalancer Services.

---

# Prometheus Monitoring

Prometheus was configured to collect:

- Kubernetes Metrics
- Node Metrics
- Cluster Metrics
- Pod Metrics

Validation:

```text
Status → Targets
```

Verified Targets:

- kubelet
- apiserver
- node-exporter
- kube-state-metrics
- prometheus

All targets were healthy and reporting as UP.

---

# Grafana Monitoring

Grafana dashboards were used to visualize cluster and application metrics.

Validated Dashboards:

- Kubernetes Cluster Dashboard
- Node Dashboard
- Pod Dashboard

Metrics Observed:

- CPU Utilization
- Memory Utilization
- Running Pods
- Deployment Status
- Cluster Health
- Node Health

---

# Cluster Health Monitoring

Monitored Metrics:

- Node Availability
- CPU Usage
- Memory Usage
- Network Usage
- Running Pods
- Cluster Status

Validation:

```bash
kubectl get nodes

kubectl top nodes
```

---

# Application Health Monitoring

Monitored Metrics:

- Deployment Availability
- Pod Status
- Pod Restart Count
- CPU Utilization
- Memory Utilization
- Application Availability
- Service Availability

Validation:

```bash
kubectl get deployments -n trend

kubectl get pods -n trend

kubectl get svc -n trend
```

---

# Documentation

A detailed deployment guide is available at:

```text
docs/Application_Deployment.docx
```

Contents:

- Architecture Diagram
- Terraform Setup
- Jenkins Configuration
- Docker Implementation
- DockerHub Integration
- EKS Setup
- Kubernetes Deployment
- Jenkins Pipeline Flow
- Monitoring Setup
- Screenshots
- Validation Steps

---

# Screenshots Included

## Terraform

- Terraform Init
- Terraform Validate
- Terraform Plan
- Terraform Apply
- Terraform Outputs

## Jenkins

- Jenkins Dashboard
- Pipeline Configuration
- Successful Build
- Console Output

## Docker

- Docker Build
- Docker Images
- Running Container

## DockerHub

- Repository
- Image Tags

## Amazon EKS

- Cluster
- Worker Nodes

## Kubernetes

- Namespace
- Deployment
- Pods
- Services
- LoadBalancer

## Monitoring

- Prometheus Targets
- Grafana Dashboards
- Monitoring Pods

## Application

- Trend Application Home Page

---

# Results

✅ Infrastructure Provisioned using Terraform

✅ Jenkins Installed and Configured

✅ GitHub Webhook Integration Completed

✅ Docker Image Built and Pushed to DockerHub

✅ Amazon EKS Cluster Created Successfully

✅ Kubernetes Deployment Automated using Jenkins

✅ Application Exposed through AWS LoadBalancer

✅ Prometheus Monitoring Implemented

✅ Grafana Dashboards Configured

✅ Cluster and Application Health Monitoring Enabled

✅ Complete Documentation and Screenshots Included

---

# Author

**Nalini Selvaraj**

GitHub: https://github.com/Nalini-0212

DockerHub: https://hub.docker.com/repository/docker/naliniselv/trend/general