terraform {
   required_providers {
     checkpoint = {
       source = "checkpointsw/checkpoint"
#       version = "~> 1.1.0"
     }
   }
}

provider "checkpoint" {
  # Configuration options
}



module "policy" {
  source = "./policy"
}

// Example 1 - Trigger the publish resource every time there is a change on any of the configuration files in a specific module
// Expression to use to hash all files in directory policy that is used by the policy module
locals {
  publish_triggers = [for filename in fileset(path.module, "policy/*.tf"): filesha256(filename)]
}

// Triggers publish if any of the hashes of the files in the policy directory changed.
resource "checkpoint_management_publish" "publish" {
  depends_on = [ module.policy ]
  triggers = local.publish_triggers
  run_publish_on_destroy = true
}

//Example 2 - Trigger the publish resource if version number is changed 
// Set the publish version number (this expression can be improved and made more intelligent)
#locals {
#  publish_version = [1]
#}

// Triggers publish if version number in publish changes
#resource "checkpoint_management_publish" "publish" {
#  depends_on = [ module.policy ]
#  triggers = local.publish_version
#}

variable "policy_install" {
  type    = bool
  default = false
  description = "Set to true to install policy"
}

resource "null_resource" "installpolicy" {
  count = var.policy_install ? 1: 0

  triggers = {
    version = "1"
}
  provisioner  "local-exec" {
  command = "/home/ubuntu/Terraform_Module_Test/installpolicy.sh"
  interpreter = ["/bin/bash"]
}
depends_on = [checkpoint_management_publish.publish]
}
resource "checkpoint_management_logout" "logout" {
  depends_on = [checkpoint_management_publish.publish]
}
