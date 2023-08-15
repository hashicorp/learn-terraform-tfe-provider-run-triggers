# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  k8s_ops_members = csvdecode(file("assets/k8s.csv"))
}

resource "tfe_team" "k8s_ops" {
  name         = "${var.tfc_k8s_team_name}-${random_pet.learn.id}"
  organization = var.tfc_org
  visibility   = "organization"
}

resource "tfe_team_organization_member" "k8s_ops" {
  for_each = { for k8s_ops_members in local.k8s_ops_members : k8s_ops_members.email => k8s_ops_members... }

  team_id                    = tfe_team.k8s_ops.id
  organization_membership_id = data.tfe_organization_membership.all[each.key].id
}

# Get Consul and Vault workspace IDs
data "tfe_workspace_ids" "consul_vault" {
  names        = [tfe_workspace.consul.name, tfe_workspace.vault.name]
  organization = var.tfc_org
}

# K8s workspaces
resource "tfe_workspace" "k8s" {
  name         = "${var.tfc_k8s_workspace_name}-${random_pet.learn.id}"
  organization = var.tfc_org
  project_id   = tfe_project.k8s_consul_vault_project.id

  vcs_repo {
    identifier     = "${var.github_username}/learn-terraform-pipelines-k8s"
    oauth_token_id = var.vcs_oauth_token_id
  }

  remote_state_consumer_ids = values(data.tfe_workspace_ids.consul_vault.ids)

  queue_all_runs = false
}

# K8s Ops team should only have write access to their workspaces
resource "tfe_team_access" "k8s_team" {
  access       = "write"
  team_id      = tfe_team.k8s_ops.id
  workspace_id = tfe_workspace.k8s.id
}

# k8s variables
resource "tfe_variable" "k8s_google_project" {
  key          = "google_project"
  value        = var.google_project_id
  category     = "terraform"
  workspace_id = tfe_workspace.k8s.id
  description  = "Google Project to deploy K8s"
}

resource "tfe_variable" "k8s_cluster_name" {
  key          = "cluster_name"
  value        = var.k8s_cluster_name
  category     = "terraform"
  workspace_id = tfe_workspace.k8s.id
  description  = "Name of Kubernetes cluster"
}

resource "tfe_variable" "k8s_region" {
  key          = "region"
  value        = var.region
  category     = "terraform"
  workspace_id = tfe_workspace.k8s.id
  description  = "GCP region to deploy clusters"
}