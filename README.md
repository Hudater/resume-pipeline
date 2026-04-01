# Resume Pipeline

A fully automated resume deployment pipeline that serves a PDF resume via Cloudflare Workers.

## Overview

This project deploys a resume to `resume.hudater.dev` using:
- **Cloudflare Workers** - Serverless compute for serving the resume
- **Cloudflare KV** - Storage for the resume PDF
- **OpenTofu** - Infrastructure as Code for resource management
- **GitHub Actions** - CI/CD automation

## Architecture

```txt
GitHub Repository
    ↓
GitHub Actions Workflow
    ↓
OpenTofu (IaC)
    ↓
Cloudflare (Workers + KV)
    ↓
resume.hudater.dev
```

## Project Structure

```txt
resume-pipeline/
├── iac/                          # Infrastructure as Code
│   ├── main.tf                   # Main Cloudflare resources
│   ├── outputs.tf                # Terraform outputs
│   └── variable.tf               # Variable definitions
├── worker/                       # Cloudflare Worker code
│   └── index.js                  # Worker handler
├── assets/                       # Static assets
│   └── Censored_Harshit_SRE_Infrastructure_DevOps_Resume.pdf
└── .github/workflows/
    └── deploy.yml                # GitHub Actions workflow
```

## How It Works

1. **Code Push** - Push changes to the `main` branch
2. **GitHub Actions** - Workflow triggers automatically
3. **OpenTofu Plan** - Validates and plans infrastructure changes
4. **OpenTofu Apply** - Deploys changes to Cloudflare (main branch only)
5. **PDF Upload** - Uploads resume PDF to Cloudflare KV namespace
6. **Live** - Resume is now served at `resume.hudater.dev`

## Deployment Workflow

The GitHub Actions workflow:
- Checks code formatting with `tofu fmt`
- Initializes Terraform with `tofu init`
- Validates configuration with `tofu validate`
- Plans changes and comments on PRs
- Applies changes automatically on push to `main`
- Uploads the resume PDF to KV storage

## Requirements

- Cloudflare account with API token
- Terraform Cloud account with `resume-pipeline` workspace
- GitHub repository with Actions enabled
- Resume PDF file in `assets/` directory

## Secrets

Configure these GitHub repository secrets:
- `CF_API_TOKEN` - Cloudflare API token
- `CF_ACCOUNT_ID` - Cloudflare account ID
- `CF_ZONE_ID` - Zone ID for hudater.dev
- `TF_TOKEN_app_terraform_io` - Terraform Cloud API token
