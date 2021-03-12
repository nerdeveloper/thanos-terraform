resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "3.2.3"

  set {
    name  = "provider"
    value = "aws"
  }
  set {
    name  = "aws.zoneType"
    value = "public"
  }

  set {
    name  = "txtOwnerId"
    value = "my-identifier"
  }
  set {
    name  = "domainFilters[0]"
    value = var.domainFilters
  }
  set {
    name  = "policy"
    value = "sync"
  }
  set {
    name  = "aws.region"
    value = var.region
  }

  set {
    name  = "txtPrefix"
    value = "prefix-"
  }


}


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = var.role
  policy_arn = var.policy_arn
}
