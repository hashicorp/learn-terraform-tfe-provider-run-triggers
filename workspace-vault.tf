# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  vault_ops_members = csvdecode(file("assets/vault.csv"))
}

resource "tfe_team" "vault_ops" {
  name         = "${var.tfc_vault_team_name}-${random_pet.learn.id}"
  organization = var.tfc_org
  visibility   = "organization"
}

# resource "tfe_organization_membership" "vault_ops" {
#   for_each = { for vault_ops_members in local.vault_ops_members : vault_ops_members.email => vault_ops_members... }

#   organization = var.tfc_org
#   email        = each.key
# }

resource "tfe_team_organization_member" "vault_ops" {
  for_each = { for vault_ops_members in local.vault_ops_members : vault_ops_members.email => vault_ops_members... }

  team_id                    = tfe_team.vault_ops.id
  organization_membership_id = data.tfe_organization_membership.all[each.key].id
}

# Vault workspace
resource "tfe_workspace" "vault" {
  name         = "${var.tfc_vault_workspace_name}-${random_pet.learn.id}"
  organization = var.tfc_org
  project_id   = tfe_project.k8s_consul_vault_project.id

  vcs_repo {
    identifier     = "${var.github_username}/learn-terraform-pipelines-vault"
    oauth_token_id = var.vcs_oauth_token_id
  }

  queue_all_runs = false
}

# Vault Ops team should only have write access to their workspaces
resource "tfe_team_access" "vault_team" {
  access       = "write"
  team_id      = tfe_team.vault_ops.id
  workspace_id = tfe_workspace.vault.id
}

## Vault Variables
resource "tfe_variable" "vault_cluster_workspace" {
  key          = "cluster_workspace"
  value        = tfe_workspace.k8s.name
  category     = "terraform"
  workspace_id = tfe_workspace.vault.id
  description  = "Workspace that created the Kubernetes k8s"
}

resource "tfe_variable" "vault_consul_workspace" {
  key          = "consul_workspace"
  value        = tfe_workspace.consul.name
  category     = "terraform"
  workspace_id = tfe_workspace.vault.id
  description  = "Workspace that created the Consul"
}

resource "tfe_variable" "vault_organization" {
  key          = "organization"
  value        = var.tfc_org
  category     = "terraform"
  workspace_id = tfe_workspace.vault.id
  description  = "Organization of workspace that created the Kubernetes k8s"
}
