resource "shoreline_notebook" "jenkins_run_failure_total_incident" {
  name       = "jenkins_run_failure_total_incident"
  data       = file("${path.module}/data/jenkins_run_failure_total_incident.json")
  depends_on = [shoreline_action.invoke_memory_disk_network_jenkins_logs,shoreline_action.invoke_restart_jenkins_service]
}

resource "shoreline_file" "memory_disk_network_jenkins_logs" {
  name             = "memory_disk_network_jenkins_logs"
  input_file       = "${path.module}/data/memory_disk_network_jenkins_logs.sh"
  md5              = filemd5("${path.module}/data/memory_disk_network_jenkins_logs.sh")
  description      = "Infrastructure issues: When running Jenkins on an infrastructure that is not properly set up, there may be issues with resources such as memory, disk space, or network connectivity. This could result in failed jobs and ultimately a total failure of the system."
  destination_path = "/agent/scripts/memory_disk_network_jenkins_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_jenkins_service" {
  name             = "restart_jenkins_service"
  input_file       = "${path.module}/data/restart_jenkins_service.sh"
  md5              = filemd5("${path.module}/data/restart_jenkins_service.sh")
  description      = "Restart the Jenkins server to see if the issue resolves itself."
  destination_path = "/agent/scripts/restart_jenkins_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_memory_disk_network_jenkins_logs" {
  name        = "invoke_memory_disk_network_jenkins_logs"
  description = "Infrastructure issues: When running Jenkins on an infrastructure that is not properly set up, there may be issues with resources such as memory, disk space, or network connectivity. This could result in failed jobs and ultimately a total failure of the system."
  command     = "`chmod +x /agent/scripts/memory_disk_network_jenkins_logs.sh && /agent/scripts/memory_disk_network_jenkins_logs.sh`"
  params      = ["JENKINS_SERVER_ADDRESS"]
  file_deps   = ["memory_disk_network_jenkins_logs"]
  enabled     = true
  depends_on  = [shoreline_file.memory_disk_network_jenkins_logs]
}

resource "shoreline_action" "invoke_restart_jenkins_service" {
  name        = "invoke_restart_jenkins_service"
  description = "Restart the Jenkins server to see if the issue resolves itself."
  command     = "`chmod +x /agent/scripts/restart_jenkins_service.sh && /agent/scripts/restart_jenkins_service.sh`"
  params      = []
  file_deps   = ["restart_jenkins_service"]
  enabled     = true
  depends_on  = [shoreline_file.restart_jenkins_service]
}

