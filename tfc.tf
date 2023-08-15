# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "tfe_project" "k8s_consul_vault_project" {
  organization = var.tfc_org
  name         = "learn-terraform-pipelines"
}

# Project variable set
resource "tfe_variable_set" "google_credentials" {
  name         = "google-credentials-${random_pet.learn.id}"
  description  = "Google credentials for ${random_pet.learn.id}"
  organization = var.tfc_org
}

resource "tfe_variable" "k8s_google_credentials" {
  key             = "GOOGLE_CREDENTIALS"
  value           = file("assets/gcp-creds.json")
  category        = "env"
  description     = "Key for Service account"
  sensitive       = true
  variable_set_id = tfe_variable_set.google_credentials.id
}

resource "tfe_project_variable_set" "project_google_credentials" {
  variable_set_id = tfe_variable_set.google_credentials.id
  project_id      = tfe_project.k8s_consul_vault_project.id
}

# Project policy set
resource "tfe_policy" "gke_3_nodes" {
  name         = "gke_3_node"
  description  = "Limit GKE clusters to 3 nodes"
  organization = var.tfc_org
  kind         = "opa"
  policy       = file("./policy/gke_3_node.rego")
  query        = "data.terraform.policies.gke_3_nodes.deny"
  enforce_mode = "mandatory"
}

resource "tfe_policy_set" "gke_policy_set" {
  name         = "gke-validation"
  description  = "Validate GKE clusters"
  organization = var.tfc_org
  kind = "opa"
  policy_ids   = [tfe_policy.gke_3_nodes.id]
}

resource "tfe_project_policy_set" "name" {
  policy_set_id = tfe_policy_set.gke_policy_set.id
  project_id    = tfe_project.k8s_consul_vault_project.id
}

locals {
  all_members = csvdecode(file("assets/all.csv"))
}

# Retrieve organization users from "all.csv"
data "tfe_organization_membership" "all" {
  for_each = { for all_members in local.all_members : all_members.email => all_members... }

  organization = var.tfc_org
  email        = each.key
}

# Create run trigger for [ K8s ] -> [ Consul ]
resource "tfe_run_trigger" "k8s_consul" {
  workspace_id  = tfe_workspace.consul.id
  sourceable_id = tfe_workspace.k8s.id
}

# Create run trigger for [ Consul ] -> [ Vault ]
resource "tfe_run_trigger" "consul_vault" {
  workspace_id  = tfe_workspace.vault.id
  sourceable_id = tfe_workspace.consul.id
}