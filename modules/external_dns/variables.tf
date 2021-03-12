variable "domainFilters" {
  type = string
}
variable "region" {
  type = string
  description = "(optional) Region where the K8 Cluster is hosted"
}
variable "role" {
  type = string
  default = null
}
variable "policy_arn" {
  type = string
  default = null
}
