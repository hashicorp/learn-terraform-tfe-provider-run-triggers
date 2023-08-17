# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Google
variable "google_project_id" {
  description = "The Google Project that these workspaces will deploy to"
}

# GitHub
variable "vcs_oauth_token_id" {
  description = "The VCS OAuth token"
}


variable "github_username" {
  description = "The GH account into which you forked the example repositories"
}

# TFC organization, project, and team names
variable "tfc_org" {
  description = "The Terraform Cloud organization to create things in"
}

variable "tfc_project_name" {
  description = "The name of the project to createthe workspaces in"
  default     = "learn-terraform-pipelines"
}
variable "tfc_admin_team_name" {
  description = "The Terraform Cloud team for pipelines admin"
  default     = "tf-learn-admin"
}

variable "tfc_k8s_team_name" {
  description = "The Terraform Cloud team for Kubernetes operators"
  default     = "tf-learn-k8s-ops"
}

variable "tfc_consul_team_name" {
  description = "The Terraform Cloud team for Consul operators"
  default     = "tf-learn-consul-ops"
}

variable "tfc_vault_team_name" {
  description = "The Terraform Cloud team for Vault operators"
  default     = "tf-learn-vault-ops"
}

# Kubernetes workspace and variables
variable "tfc_k8s_workspace_name" {
  description = "Kubernetes workspace name"
  default     = "learn-terraform-pipelines-k8s"
}

variable "k8s_cluster_name" {
  description = "ClusterName variable value for k8s workspace"
  default     = "tfc-pipelines"
}

variable "region" {
  description = "Google Cloud Region"
  default     = "us-central1"
}

# Consul workspace and variables
variable "tfc_consul_workspace_name" {
  description = "Consul workspace name"
  default     = "learn-terraform-pipelines-consul"
}

variable "consul_namespace" {
  description = "K8s namespace for Consul and Vault"
  default     = "hashicorp-learn"
}

variable "consul_release_name" {
  description = "Release name for Consul and Vault"
  default     = "hashicorp-learn"
}

# Vault workspace and variables
variable "tfc_vault_workspace_name" {
  description = "Vault workspace name"
  default     = "learn-terraform-pipelines-vault"
}
