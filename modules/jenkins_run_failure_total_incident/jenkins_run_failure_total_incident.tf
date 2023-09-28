resource "shoreline_notebook" "jenkins_run_failure_total_incident" {
  name       = "jenkins_run_failure_total_incident"
  data       = file("${path.module}/data/jenkins_run_failure_total_incident.json")
  depends_on = [shoreline_action.invoke_check_sys_resources,shoreline_action.invoke_restart_jenkins_service]
}

resource "shoreline_file" "check_sys_resources" {
  name             = "check_sys_resources"
  input_file       = "${path.module}/data/check_sys_resources.sh"
  md5              = filemd5("${path.module}/data/check_sys_resources.sh")
  description      = "Infrastructure issues: When running Jenkins on an infrastructure that is not properly set up, there may be issues with resources such as memory, disk space, or network connectivity. This could result in failed jobs and ultimately a total failure of the system."
  destination_path = "/agent/scripts/check_sys_resources.sh"
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

resource "shoreline_action" "invoke_check_sys_resources" {
  name        = "invoke_check_sys_resources"
  description = "Infrastructure issues: When running Jenkins on an infrastructure that is not properly set up, there may be issues with resources such as memory, disk space, or network connectivity. This could result in failed jobs and ultimately a total failure of the system."
  command     = "`chmod +x /agent/scripts/check_sys_resources.sh && /agent/scripts/check_sys_resources.sh`"
  params      = ["JENKINS_SERVER_ADDRESS"]
  file_deps   = ["check_sys_resources"]
  enabled     = true
  depends_on  = [shoreline_file.check_sys_resources]
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

