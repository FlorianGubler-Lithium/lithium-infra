# Lithium Infrastructure

A complete infrastructure-as-code solution for deploying and managing a Kubernetes cluster on Proxmox with comprehensive CI/CD, monitoring, and networking capabilities.

## Purpose

This repository contains the infrastructure code needed to bootstrap and manage the Lithium infrastructure stack. It automates the provisioning of VMs, Kubernetes cluster setup, and deployment of supporting services like ArgoCD, Prometheus, Grafana, and Traefik.

## Directory Structure

```
lithium-infra/
├── ansible/              # VM and Kubernetes configuration via Ansible playbooks
│   ├── playbooks/        # Main playbooks (k8s setup, GitHub runners, etc.)
│   └── roles/            # Reusable Ansible roles
├── terraform/            # Infrastructure provisioning on Proxmox
│   └── vm-configs/       # VM-specific configurations for dev and prod
├── cicd/                 # Kubernetes Helm charts for CI/CD and services
│   ├── argocd/           # GitOps deployment tool
│   ├── traefik/          # Ingress controller
│   ├── prometheus/       # Monitoring
│   ├── grafana/          # Metrics visualization
│   └── [other services]/ # Additional Kubernetes services
└── docs/                 # Documentation
```

## Quick Start

The bootstrap process requires a **Proxmox host** and a **management machine** (for running Terraform and Ansible).

### Prerequisites

1. **Proxmox VE** installed on your target host
2. **Management machine** with:
   - Terraform
   - Ansible
   - Git

### Getting Started

1. **Read the bootstrap documentation** for detailed setup instructions:
   ```bash
   cat docs/bootstrap-setup.md
   ```

2. **Clone this repository** on your management machine and follow the Terraform/Ansible initialization steps outlined in the bootstrap doc.

3. **Configure Terraform** with your Proxmox credentials and run:
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

4. **Run Ansible playbooks** to configure the Kubernetes cluster:
   ```bash
   cd ansible
   ansible-playbook playbooks/site.yml
   ```

## Key Components

- **Terraform**: Provisions VMs on Proxmox
- **Ansible**: Configures VMs and Kubernetes clusters
- **Kubernetes**: Container orchestration platform
- **ArgoCD**: Continuous deployment and GitOps
- **Traefik**: Ingress controller and reverse proxy
- **Prometheus & Grafana**: Monitoring and visualization

For detailed setup instructions, start with **[docs/bootstrap-setup.md](docs/bootstrap-setup.md)**.

