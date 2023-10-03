terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "cassandra_disk_space_not_reclaimed_after_adding_new_nodes" {
  source    = "./modules/cassandra_disk_space_not_reclaimed_after_adding_new_nodes"

  providers = {
    shoreline = shoreline
  }
}