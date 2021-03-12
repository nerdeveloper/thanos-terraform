#---------------------
# HOSTED ZONES
#--------------------

module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 1.0"

  zones = {
    "k8s.lawrencetalks.com" = {
      comment = "k8s.lawrencetalks.com"
    }
  }

  tags = local.tags
}
#------------------------------
# VPC
#------------------------------
module "vpc" {
  source                                 = "terraform-aws-modules/vpc/aws"
  name                                   = "${local.project_name}-vpc"
  cidr                                   = var.vpc_subnet_cidr
  azs                                    = data.aws_availability_zones.available.names
  private_subnets                        = var.private_subnet_cidr
  public_subnets                         = var.public_subnet_cidr
  database_subnets                       = var.database_subnet_cidr
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true
  enable_nat_gateway                     = true
  enable_vpn_gateway                     = true
  enable_dns_hostnames                   = true
  enable_dns_support                     = true

  tags = {
    Name                                            = "${var.eks_cluster_name}-vpc"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  public_subnet_tags = {
    Name                                            = "${var.eks_cluster_name}-eks-public"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = 1
  }
  private_subnet_tags = {
    Name                                            = "${var.eks_cluster_name}-eks-private"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = 1
  }
  database_subnet_tags = {
    Name                                            = "${var.eks_cluster_name}-eks-database"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"

  }
}



#------------------------------
# EKS
#------------------------------
module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "13.2.1"
  cluster_name                    = var.eks_cluster_name
  cluster_version                 = var.eks_k8s_version
  subnets                         = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id
  tags                            = local.tags
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true
  map_users                       = local.maps_users
  worker_groups = local.worker_groups
}

#------------------------------------------------
# Auto Connect to EKS CLuster
#-----------------------------------------------

module "update_kubeconfig" {
  source = "./modules/null_resources"
  command = "aws eks update-kubeconfig --name ${var.eks_cluster_name} --region ${var.region}"
  depends_on = [module.eks]

}

#------------------------------------------------
# Nginx Ingress Controller  Installation
#-----------------------------------------------

module "nginx_ingress" {
  source = "./modules/null_resources"
  command = "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud/deploy.yaml; sleep 15;"
  depends_on = [module.update_kubeconfig]
}

#----------------------------
# Terraform state
#----------------------------

module "terraform_remote_state" {
  source = "./modules/remote_state"
  region = var.region
  tags   = local.tags
}

# ------------------------------
# External DNS
# ------------------------------
module "external_dns" {
  source        = "./modules/external_dns"
  domainFilters = "k8s.lawrencetalks.com"
  region = var.region
  role = module.eks.worker_iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}
