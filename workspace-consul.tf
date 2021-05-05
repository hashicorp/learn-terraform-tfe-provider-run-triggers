locals {
  consul_ops_members = csvdecode(file("assets/consul.csv"))
}

resource "tfe_team" "consul_ops" {
  name         = "${var.tfc_consul_team_name}-${random_pet.learn.id}"
  organization = var.tfc_org
  visibility   = "organization"
}

# resource "tfe_organization_membership" "consul_ops" {
#   for_each = { for consul_ops_members in local.consul_ops_members : consul_ops_members.email => consul_ops_members... }

#   organization = var.tfc_org
#   email        = each.key
# }

resource "tfe_team_organization_member" "consul_ops" {
  for_each = { for consul_ops_members in local.consul_ops_members : consul_ops_members.email => consul_ops_members... }

  team_id                    = tfe_team.consul_ops.id
  organization_membership_id = data.tfe_organization_membership.all[each.key].id
}

# Get Vault workspace IDs
data "tfe_workspace_ids" "vault" {
  names        = [tfe_workspace.vault.name]
  organization = var.tfc_org
}

# Consul workspace
resource "tfe_workspace" "consul" {
  name         = "${var.tfc_consul_workspace_name}-${random_pet.learn.id}"
  organization = var.tfc_org

  vcs_repo {
    identifier         = var.consul_repo_name
    oauth_token_id     = var.vcs_oauth_token_id
    ingress_submodules = true
  }

  remote_state_consumer_ids = values(data.tfe_workspace_ids.vault.ids)

  queue_all_runs = false
}

# Consul Ops team should only have write access to their workspaces
resource "tfe_team_access" "consul_team" {
  access       = "write"
  team_id      = tfe_team.consul_ops.id
  workspace_id = tfe_workspace.consul.id
}

# Consul variables
resource "tfe_variable" "consul_cluster_workspace" {
  key          = "cluster_workspace"
  value        = tfe_workspace.k8s.name
  category     = "terraform"
  workspace_id = tfe_workspace.consul.id
  description  = "Workspace that created the Kubernetes k8s"
}

resource "tfe_variable" "consul_organization" {
  key          = "organization"
  value        = var.tfc_org
  category     = "terraform"
  workspace_id = tfe_workspace.consul.id
  description  = "Organization of workspace that created the Kubernetes k8s"
}

resource "tfe_variable" "consul_namespace" {
  key          = "namespace"
  value        = var.consul_namespace
  category     = "terraform"
  workspace_id = tfe_workspace.consul.id
  description  = "Namespace to deploy the Consul Helm chart"
}

resource "tfe_variable" "consul_release_name" {
  key          = "release_name"
  value        = var.consul_release_name
  category     = "terraform"
  workspace_id = tfe_workspace.consul.id
  description  = "Release name for Consul"
}

resource "tfe_variable" "consul_google_credentials" {
  key          = "GOOGLE_CREDENTIALS"
  value        = file("assets/gcp-creds.json")
  category     = "env"
  workspace_id = tfe_workspace.consul.id
  description  = "Key for Service account"
  sensitive    = true
}
