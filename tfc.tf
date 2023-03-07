# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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
