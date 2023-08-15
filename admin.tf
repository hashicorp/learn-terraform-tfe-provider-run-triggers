# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  admin_members = csvdecode(file("assets/admin.csv"))
}

resource "tfe_team" "admin" {
  name         = "${var.tfc_admin_team_name}-${random_pet.learn.id}"
  organization = var.tfc_org
  visibility   = "organization"
}

resource "tfe_team_organization_member" "admin" {
  for_each = { for admin_members in local.admin_members : admin_members.email => admin_members... }

  team_id                    = tfe_team.admin.id
  organization_membership_id = data.tfe_organization_membership.all[each.key].id
}

# Admin access for the entire project will grant admin access
# to every workspace in the project
resource "tfe_team_project_access" "project_admin_team" {
  access     = "admin"
  team_id    = tfe_team.admin.id
  project_id = tfe_project.k8s_consul_vault_project.id
}