resource "aws_grafana_workspace" "grafana" {
  name                     = "prod-grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_IAM"]
  permission_type          = "SERVICE_MANAGED"
}

resource "aws_grafana_workspace_data_source" "amp_ds" {
  workspace_id = aws_grafana_workspace.grafana.id
  name         = "AMP"
  type         = "prometheus"

  url = aws_prometheus_workspace.amp.prometheus_endpoint

  json_data = jsonencode({
    httpMethod = "POST"
    sigV4Auth  = true
  })
}
