output "grafana_url" {
  value = aws_grafana_workspace.grafana.endpoint
}

output "amp_endpoint" {
  value = aws_prometheus_workspace.amp.prometheus_endpoint
}
