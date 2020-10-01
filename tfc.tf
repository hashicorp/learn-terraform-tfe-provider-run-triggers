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
