# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.

locals {
  project_vars = yamldecode(file("${find_in_parent_folders("project-vars.yml")}"))
  gcp_vars     = yamldecode(file("${find_in_parent_folders("gcp-vars.yml")}"))
}

terraform {
  source = "${dirname(find_in_parent_folders("root.yml"))}//terraform-services/gcp/compute-instance"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  app_code    = "labbox"
  owner       = local.gcp_vars.owner
  environment = local.gcp_vars.environment

  machine_type  = "e2-medium"
  machine_count = 1
  image         = "ubuntu-2110"

  zone = local.gcp_vars.default_zone
}
