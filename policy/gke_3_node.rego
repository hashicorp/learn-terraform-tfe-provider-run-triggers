package terraform.policies.gke_3_nodes

import input.plan as plan

deny[msg] {
  r := plan.resource_changes[_]
  r.type == "google_container_node_pool"
  r.change.after.node_count > 3
  msg := sprintf("%v has more than 3 nodes", [r.name])
}