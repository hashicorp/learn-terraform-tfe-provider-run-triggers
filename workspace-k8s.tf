locals {
  k8s_ops_members = csvdecode(file("assets/k8s.csv"))
}

resource "tfe_team" "k8s_ops" {
  name         = "${var.tfc_k8s_team_name}-${random_pet.learn.id}"
  organization = var.tfc_org
  visibility   = "organization"
}

# resource "tfe_organization_membership" "k8s_ops" {
#   for_each = { for k8s_ops_members in local.k8s_ops_members : k8s_ops_members.email => k8s_ops_members... }

#   organization = var.tfc_org
#   email        = each.key
# }

resource "tfe_team_organization_member" "k8s_ops" {
  for_each = { for k8s_ops_members in local.k8s_ops_members : k8s_ops_members.email => k8s_ops_members... }

  team_id                    = tfe_team.k8s_ops.id
  organization_membership_id = data.tfe_organization_membership.all[each.key].id
}

# K8s workspaces
resource "tfe_workspace" "k8s" {
  name         = "${var.tfc_k8s_workspace_name}-${random_pet.learn.id}"
  organization = var.tfc_org

  vcs_repo {
    identifier     = var.k8s_repo_name
    oauth_token_id = var.vcs_oauth_token_id
  }

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

resource "tfe_variable" "k8s_username" {
  key          = "username"
  value        = var.k8s_username
  category     = "terraform"
  workspace_id = tfe_workspace.k8s.id
  description  = "Username for GKE clusters"
}

resource "tfe_variable" "k8s_password" {
  key          = "password"
  value        = var.k8s_password
  category     = "terraform"
  workspace_id = tfe_workspace.k8s.id
  description  = "Password for GKE clusters"
  sensitive    = true
}

resource "tfe_variable" "k8s_cluster_name" {
  key          = "cluster_name"
  value        = var.k8s_cluster_name
  category     = "terraform"
  workspace_id = tfe_workspace.k8s.id
  description  = "Name of Kubernetes cluster"
}

resource "tfe_variable" "k8s_enable_consul_and_vault" {
  key          = "enable_consul_and_vault"
  value        = true
  category     = "terraform"
  workspace_id = tfe_workspace.k8s.id
  description  = "Enable Consul and Vault for the secrets cluster"
}

resource "tfe_variable" "k8s_region" {
  key          = "region"
  value        = var.region
  category     = "terraform"
  workspace_id = tfe_workspace.k8s.id
  description  = "GCP region to deploy clusters"
}

resource "tfe_variable" "k8s_google_credentials" {
  key          = "GOOGLE_CREDENTIALS"
  value        = file("assets/gcp-creds.json")
  category     = "env"
  workspace_id = tfe_workspace.k8s.id
  description  = "Key for Service account"
  sensitive    = true
}
