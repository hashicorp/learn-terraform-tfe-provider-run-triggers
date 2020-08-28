# Google
variable "google_project_id" {
  description = "The Google Project that these workspaces will deploy to"
  default     = "REPLACE_ME"
}

# GitHub
variable "vcs_oauth_token_id" {
  description = "The VCS OAuth token"
  default     = "REPLACE_ME"
}

variable "k8s_repo_name" {
  description = "The GH repo where the k8s configuration lives"
  default     = "REPLACE_ME/learn-terraform-pipelines-k8s"
}

variable "consul_repo_name" {
  description = "The GH repo where the Consul configuration lives"
  default     = "REPLACE_ME/learn-terraform-pipelines-consul"
}

variable "vault_repo_name" {
  description = "The GH repo where the Vault configuration lives"
  default     = "REPLACE_ME/learn-terraform-pipelines-vault"
}

# TFC Organization and team names
variable "tfc_org" {
  description = "The Terraform Cloud organization to create things in"
  default     = "REPLACE_ME"
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

variable "k8s_username" {
  description = "The Google Project that these workspaces will deploy to"
  default     = "hashicorp"
}

variable "k8s_password" {
  description = "Password variable value for k8s workspace"
  default     = "infrastructurepipelines"
}

variable "k8s_cluster_name" {
  description = "ClusterName variable value for k8s workspace"
  default     = "tfc-pipelines"
}

variable "region" {
  description = "Google Cloud Region"
  default     = "us-west1"
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
