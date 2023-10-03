resource "shoreline_notebook" "cassandra_disk_space_not_reclaimed_after_adding_new_nodes" {
  name       = "cassandra_disk_space_not_reclaimed_after_adding_new_nodes"
  data       = file("${path.module}/data/cassandra_disk_space_not_reclaimed_after_adding_new_nodes.json")
  depends_on = [shoreline_action.invoke_cassandra_cluster_check,shoreline_action.invoke_cassandra_repair_script]
}

resource "shoreline_file" "cassandra_cluster_check" {
  name             = "cassandra_cluster_check"
  input_file       = "${path.module}/data/cassandra_cluster_check.sh"
  md5              = filemd5("${path.module}/data/cassandra_cluster_check.sh")
  description      = "Review the Cassandra cluster configuration to ensure that it is properly set up for the number of nodes currently in use and the expected growth of the cluster."
  destination_path = "/agent/scripts/cassandra_cluster_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cassandra_repair_script" {
  name             = "cassandra_repair_script"
  input_file       = "${path.module}/data/cassandra_repair_script.sh"
  md5              = filemd5("${path.module}/data/cassandra_repair_script.sh")
  description      = "Run a repair on the Cassandra cluster to clean up any old or unused data that may be taking up disk space."
  destination_path = "/agent/scripts/cassandra_repair_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cassandra_cluster_check" {
  name        = "invoke_cassandra_cluster_check"
  description = "Review the Cassandra cluster configuration to ensure that it is properly set up for the number of nodes currently in use and the expected growth of the cluster."
  command     = "`chmod +x /agent/scripts/cassandra_cluster_check.sh && /agent/scripts/cassandra_cluster_check.sh`"
  params      = ["PATH_TO_CASSANDRA_CONFIG_FILE","NUMBER_OF_CURRENT_NODES","NUMBER_OF_EXPECTED_NODES"]
  file_deps   = ["cassandra_cluster_check"]
  enabled     = true
  depends_on  = [shoreline_file.cassandra_cluster_check]
}

resource "shoreline_action" "invoke_cassandra_repair_script" {
  name        = "invoke_cassandra_repair_script"
  description = "Run a repair on the Cassandra cluster to clean up any old or unused data that may be taking up disk space."
  command     = "`chmod +x /agent/scripts/cassandra_repair_script.sh && /agent/scripts/cassandra_repair_script.sh`"
  params      = ["PATH_TO_CASSANDRA_HOME"]
  file_deps   = ["cassandra_repair_script"]
  enabled     = true
  depends_on  = [shoreline_file.cassandra_repair_script]
}

