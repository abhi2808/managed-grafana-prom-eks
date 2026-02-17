provider "helm" {
  kubernetes={
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

resource "helm_release" "prometheus" {
  name      = "prometheus"
  namespace = "monitoring"

  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  values = [
    yamlencode({
      serviceAccounts = {
        server = {
          name = "prometheus-server"
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.amp_irsa.arn
          }
        }
      }

      server = {
        remoteWrite = [{
          url = "${aws_prometheus_workspace.amp.prometheus_endpoint}api/v1/remote_write"
        }]
      }
    })
  ]
}
