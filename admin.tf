locals {
  admin_members = csvdecode(file("assets/admin.csv"))
}

resource "tfe_team" "admin" {
  name         = var.tfc_admin_team_name
  organization = var.tfc_org
  visibility = "organization"
}

# resource "tfe_organization_membership" "admin" {
#   for_each = { for admin_members in local.admin_members : admin_members.email => admin_members... }

#   organization = var.tfc_org
#   email        = each.key
# }

resource "tfe_team_organization_member" "admin" {
  for_each = { for admin_members in local.admin_members : admin_members.email => admin_members... }

  team_id                    = tfe_team.admin.id
  organization_membership_id = tfe_organization_membership.all[each.key].id
}

# Admin team should have admin access to k8s workspace
resource "tfe_team_access" "k8s_admin_team" {
  access       = "admin"
  team_id      = tfe_team.admin.id
  workspace_id = tfe_workspace.k8s.id
}

# Admin team should have admin access to consul workspace
resource "tfe_team_access" "consul_admin_team" {
  access       = "admin"
  team_id      = tfe_team.admin.id
  workspace_id = tfe_workspace.consul.id
}

# Admin team should have admin access to vault workspace
resource "tfe_team_access" "vault_admin_team" {
  access       = "admin"
  team_id      = tfe_team.admin.id
  workspace_id = tfe_workspace.vault.id
}